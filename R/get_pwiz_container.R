#' Get Proteowizard (pwiz) Docker Container
#'
#' Pull the pwiz docker container (`chambm/pwiz-skyline-i-agree-to-the-vendor-licenses:latest`) from Docker Hub.
#'
#' @export

get_pwiz_container <- function()
{
  docker_env <- stevedore::docker_client()
  docker_env$image$pull('chambm/pwiz-skyline-i-agree-to-the-vendor-licenses')

  return(invisible(NULL))

}
