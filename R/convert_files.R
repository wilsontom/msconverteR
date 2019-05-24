#' Covert Files
#'
#' Convert vendor specific mass spectrometry files to the open `.mzML` format. This functions makes a `system` call to `docker` in order to convert files.
#' Conversion arguments should be supplied to the `args` parameter exactly as they would be for `msconvert` but omitting the `--filter` prefix.
#'
#' For example to convert a file with vendor specific centroiding only;
#'
#' `convert_files(rawFiels, args = 'peakPicking true1-')`
#'
#' To only retain positive mode data;
#'
#' `convert_files(rawFiels, args = c('peakPicking true1-', 'polarity positive'))`
#'
#'
#' @param files the absolute filepath vendor specific files to be converted
#' @param args a character vector of `msconvert` arguments.
#' @export


convert_files <-
  function(files,
           args = c('peakPicking true1-', 'polarity positive'))
  {
    mount_point <-
      stringr::str_remove(files[1], paste0('/', basename(files[1])))

    DOCKER_CMD_A <-
      paste0(
        'docker run --rm -e WINEDEBUG=-all -v ',
        mount_point,
        ':/data chambm/pwiz-skyline-i-agree-to-the-vendor-licenses wine msconvert '
      )


    command_args <- list()
    for (i in seq_along(args)) {
      command_args[[i]] <- paste0('--filter ', '"', args[i], '"')
    }


    command_args <-
      paste0(' --mzML ', do.call('paste', command_args))

    for (i in seq_along(files)) {
      DOCKER_RUN <-
        paste0(DOCKER_CMD_A, basename(files[i]), command_args)
      system(DOCKER_RUN, intern = FALSE)
    }

    return(invisible(NULL))
  }
