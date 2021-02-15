test_that("test arguments", {

  test_file <-
    list.files(system.file(package = 'msconverteR'),
               pattern = '.raw',
               full.names = TRUE)

  expect_error(
    convert_files(
      test_file,
      outpath = NULL,
      msconvert_args = 'peakPicking true1-'
    )
  )


  expect_error(
    convert_files(
      test_file,
      outpath = NULL,
      msconvert_args = 'peakPicking true1'
    )
  )


  expect_error(convert_files(
    test_file,
    outpath = NULL,
    msconvert_args = 'peakPicking true'
  ))


})
