test_that("convert_files rejects unsupported msconvert arguments", {
  input_dir <- withr::local_tempdir()
  raw_file <- local_raw_file(file.path(input_dir, "QC01.raw"))

  expect_error(
    convert_files(raw_file, outpath = NULL, msconvert_args = "peakPicking true1-"),
    "Invalid msconvert arguments"
  )

  expect_error(
    convert_files(raw_file, outpath = NULL, msconvert_args = "peakPicking true1"),
    "Invalid msconvert arguments"
  )

  expect_error(
    convert_files(raw_file, outpath = NULL, msconvert_args = "peakPicking true"),
    "Invalid msconvert arguments"
  )
})

test_that("convert_files builds mzML command in the input directory by default", {
  input_dir <- withr::local_tempdir()
  raw_file <- local_raw_file(file.path(input_dir, "sample.raw"))
  commands <- character()

  local_rebind(
    pkg_env(),
    list(.run_system = function(command) {
      commands <<- c(commands, command)
      0
    })
  )

  expect_invisible(convert_files(raw_file))
  expect_length(commands, 1)
  expect_true(grepl("docker run --rm -e WINEDEBUG=-all", commands[[1]], fixed = TRUE))
  expect_true(grepl(paste0(normalizePath(input_dir), ":/data"), commands[[1]], fixed = TRUE))
  expect_true(grepl(paste0(normalizePath(input_dir), ":/outpath"), commands[[1]], fixed = TRUE))
  expect_true(grepl("/data/sample.raw", commands[[1]], fixed = TRUE))
  expect_true(grepl("--ignoreUnknownInstrumentError  --mzML", commands[[1]], fixed = TRUE))
  expect_false(grepl(" -o /outpath/", commands[[1]], fixed = TRUE))
})

test_that("convert_files appends filters and outpath when requested", {
  input_dir <- withr::local_tempdir()
  out_dir <- withr::local_tempdir()
  raw_files <- c(
    local_raw_file(file.path(input_dir, "sample1.raw")),
    local_raw_file(file.path(input_dir, "sample2.raw"))
  )
  commands <- character()

  local_rebind(
    pkg_env(),
    list(.run_system = function(command) {
      commands <<- c(commands, command)
      0
    })
  )

  expect_invisible(
    convert_files(
      raw_files,
      outpath = out_dir,
      msconvert_args = c("peakPicking true 1-", "polarity positive"),
      docker_args = c("--user", "1000")
    )
  )

  expect_length(commands, 2)
  expect_true(all(grepl(" --user 1000 -v ", commands, fixed = TRUE)))
  expect_true(all(grepl(paste0(normalizePath(out_dir), ":/outpath"), commands, fixed = TRUE)))
  expect_true(all(grepl('--filter "peakPicking true 1-" --filter "polarity positive"', commands, fixed = TRUE)))
  expect_true(all(grepl(" -o /outpath/", commands, fixed = TRUE)))
  expect_true(any(grepl("/data/sample1.raw", commands, fixed = TRUE)))
  expect_true(any(grepl("/data/sample2.raw", commands, fixed = TRUE)))
})
