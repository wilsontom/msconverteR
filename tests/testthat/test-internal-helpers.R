test_that("internal helpers delegate to stevedore and system", {
  skip_if_not_installed("stevedore")

  local_rebind(
    asNamespace("stevedore"),
    list(
      docker_available = function() "available",
      docker_client = function() "client"
    )
  )
  local_rebind(
    baseenv(),
    list(system = function(command, intern = FALSE) {
      list(command = command, intern = intern)
    })
  )

  expect_identical(get(".docker_available", envir = pkg_env())(), "available")
  expect_identical(get(".docker_client", envir = pkg_env())(), "client")
  expect_identical(
    get(".run_system", envir = pkg_env())("echo hi"),
    list(command = "echo hi", intern = FALSE)
  )
})
