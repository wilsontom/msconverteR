test_that("get_pwiz_container reports when the pwiz image is already available", {
  fake_client <- list(
    image = list(
      list = function() {
        list(repo_tags = "chambm/pwiz-skyline-i-agree-to-the-vendor-licenses:latest")
      },
      pull = function(...) {
        stop("pull should not be called")
      }
    )
  )

  local_rebind(pkg_env(), list(.docker_client = function() fake_client))

  messages <- testthat::capture_messages(expect_invisible(get_pwiz_container()))

  expect_true(any(grepl("pwiz container available", messages, fixed = TRUE)))
})

test_that("get_pwiz_container requires an exact latest image tag", {
  for (tags in list(NULL, character(), "<none>:<none>",
                   "chambm/pwiz-skyline-i-agree-to-the-vendor-licenses",
                   "chambm/pwiz-skyline-i-agree-to-the-vendor-licenses:old",
                   "chambm/pwiz-skyline-i-agree-to-the-vendor-licenses:lates.")) {
    pulled_image <- NULL
    fake_client <- list(image = list(
      list = function() list(repo_tags = tags),
      pull = function(image) pulled_image <<- image
    ))
    local_rebind(pkg_env(), list(.docker_client = function() fake_client))

    capture.output(testthat::capture_messages(get_pwiz_container()))

    expect_identical(pulled_image, "chambm/pwiz-skyline-i-agree-to-the-vendor-licenses")
  }
})

test_that("get_pwiz_container finds the image among multiple and untagged images", {
  fake_client <- list(image = list(
    list = function() list(repo_tags = list(
      NULL,
      c("some/other:latest", "some/other:old"),
      "chambm/pwiz-skyline-i-agree-to-the-vendor-licenses:latest"
    )),
    pull = function(...) stop("pull should not be called")
  ))
  local_rebind(pkg_env(), list(.docker_client = function() fake_client))

  messages <- testthat::capture_messages(expect_invisible(get_pwiz_container()))

  expect_true(any(grepl("pwiz container available", messages, fixed = TRUE)))
})

test_that("get_pwiz_container pulls the image when it is missing", {
  pulled_image <- NULL
  fake_client <- list(
    image = list(
      list = function() {
        list(repo_tags = "some/other:image")
      },
      pull = function(image) {
        pulled_image <<- image
      }
    )
  )

  local_rebind(pkg_env(), list(.docker_client = function() fake_client))

  messages <- testthat::capture_messages(expect_invisible(get_pwiz_container()))

  expect_identical(pulled_image, "chambm/pwiz-skyline-i-agree-to-the-vendor-licenses")
  expect_true(any(grepl("pwiz container not available", messages, fixed = TRUE)))
  expect_true(any(grepl("Pulling container from docker hub", messages, fixed = TRUE)))
})
