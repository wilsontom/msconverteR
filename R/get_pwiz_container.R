#' Get Proteowizard (pwiz) Docker Container
#'
#' Pull the pwiz docker container (`chambm/pwiz-skyline-i-agree-to-the-vendor-licenses:latest`) from Docker Hub.
#'
#' @export

get_pwiz_container <- function()
{
  docker_env <- stevedore::docker_client()


  image_list <- data.frame(docker_env$image$list())


  if (TRUE %in%
      unlist(
        lapply(
          image_list$repo_tags,stringr::str_detect,
          string = 'chambm/pwiz-skyline-i-agree-to-the-vendor-licenses:latest'))) {
    message(crayon::green(clisymbols::symbol$tick, 'pwiz container avaialble'))
  } else{
    message(crayon::red(clisymbols::symbol$cross, 'pwiz container not available'))
    cat('\n')
    message(
      crayon::yellow(
        clisymbols::symbol$ellipsis,
        'Pulling container from docker hub'
      )
    )

    docker_env$image$pull('chambm/pwiz-skyline-i-agree-to-the-vendor-licenses')

  }

  return(invisible(NULL))

}
