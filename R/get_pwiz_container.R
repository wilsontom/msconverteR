#' Get Proteowizard (pwiz) Docker Container
#'
#' Pull the pwiz docker container (`chambm/pwiz-skyline-i-agree-to-the-vendor-licenses:latest`) from Docker Hub.
#'
#' @export

get_pwiz_container <- function()
{
  docker_env <- .docker_client()


  image_list <- docker_env$image$list()
  image_tags <- unlist(image_list$repo_tags, use.names = FALSE)

  if ('chambm/pwiz-skyline-i-agree-to-the-vendor-licenses:latest' %in% image_tags) {
    message(crayon::green(clisymbols::symbol$tick, 'pwiz container available'))
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
