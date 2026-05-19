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
  input_dir_root <- withr::local_tempdir()
  input_dir <- file.path(input_dir_root, "input dir")
  dir.create(input_dir)
  raw_file <- local_raw_file(file.path(input_dir, "sample.raw"))
  calls <- list()

  local_rebind(
    pkg_env(),
    list(.run_system = function(command, args = character()) {
      calls <<- c(calls, list(list(command = command, args = args)))
      0
    })
  )

  expect_invisible(convert_files(raw_file))
  expect_length(calls, 1)
  expect_identical(calls[[1]]$command, "docker")
  expect_identical(
    calls[[1]]$args,
    c(
      "run",
      "--rm",
      "-e",
      "WINEDEBUG=-all",
      "-v",
      paste0(normalizePath(input_dir), ":/data"),
      "-v",
      paste0(normalizePath(input_dir), ":/outpath"),
      "chambm/pwiz-skyline-i-agree-to-the-vendor-licenses",
      "wine",
      "msconvert",
      "/data/sample.raw",
      "--ignoreUnknownInstrumentError",
      "--mzML"
    )
  )
})

test_that("convert_files appends filters and outpath when requested", {
  input_dir_root <- withr::local_tempdir()
  input_dir <- file.path(input_dir_root, "input dir")
  dir.create(input_dir)
  out_dir_root <- withr::local_tempdir()
  out_dir <- file.path(out_dir_root, "output dir")
  dir.create(out_dir)
  raw_files <- c(
    local_raw_file(file.path(input_dir, "sample1.raw")),
    local_raw_file(file.path(input_dir, "sample2.raw"))
  )
  calls <- list()

  local_rebind(
    pkg_env(),
    list(.run_system = function(command, args = character()) {
      calls <<- c(calls, list(list(command = command, args = args)))
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

  expect_length(calls, 2)
  expect_true(all(vapply(calls, function(call) identical(call$command, "docker"), logical(1))))
  expect_true(all(vapply(calls, function(call) "--user" %in% call$args, logical(1))))
  expect_true(all(vapply(calls, function(call) "1000" %in% call$args, logical(1))))
  expect_true(all(vapply(
    calls,
    function(call) paste0(normalizePath(out_dir), ":/outpath") %in% call$args,
    logical(1)
  )))
  expect_true(all(vapply(
    calls,
    function(call) identical(
      call$args[match("--filter", call$args) + 0:3],
      c("--filter", "peakPicking true 1-", "--filter", "polarity positive")
    ),
    logical(1)
  )))
  expect_true(all(vapply(calls, function(call) tail(call$args, 2)[[1]] == "-o", logical(1))))
  expect_true(all(vapply(calls, function(call) tail(call$args, 1) == "/outpath/", logical(1))))
  expect_true(any(vapply(calls, function(call) "/data/sample1.raw" %in% call$args, logical(1))))
  expect_true(any(vapply(calls, function(call) "/data/sample2.raw" %in% call$args, logical(1))))
})
