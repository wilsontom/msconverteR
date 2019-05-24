.onLoad <-
  function(libname = find.package('msconverteR'),
           pkgname = 'msconverteR')
  {
    if (stevedore::docker_available() == FALSE) {
      message(crayon::yellow('docker must be installed before using msconverteR'))
      cat('\n')
      message(crayon::yellow('visit https://docs.docker.com/install for more details'))
    }

  }
