test_that(".onAttach is silent when docker is available", {
  local_rebind(pkg_env(), list(.docker_available = function() TRUE))

  messages <- testthat::capture_messages(
    expect_invisible(get(".onAttach", envir = pkg_env())())
  )

  expect_length(messages, 0)
})

test_that(".onAttach reports missing docker to the user", {
  local_rebind(pkg_env(), list(.docker_available = function() FALSE))

  messages <- testthat::capture_messages(
    expect_invisible(get(".onAttach", envir = pkg_env())())
  )

  expect_true(any(grepl("docker must be installed before using msconverteR", messages, fixed = TRUE)))
  expect_true(any(grepl("visit https://docs.docker.com/install for more details", messages, fixed = TRUE)))
})
