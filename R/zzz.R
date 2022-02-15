.onAttach <-
  function(...)
  {
    if (stevedore::docker_available() == FALSE) {
      packageStartupMessage(crayon::yellow('docker must be installed before using msconverteR'), appendLF = TRUE)
      packageStartupMessage(crayon::yellow('visit https://docs.docker.com/install for more details'))
    }

  }

