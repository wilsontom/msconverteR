.docker_available <- function() {
  stevedore::docker_available()
}

.docker_client <- function() {
  stevedore::docker_client()
}

.run_system <- function(command, args = character()) {
  system2(command, args = shQuote(args))
}
