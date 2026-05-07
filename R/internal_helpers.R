.docker_available <- function() {
  stevedore::docker_available()
}

.docker_client <- function() {
  stevedore::docker_client()
}

.run_system <- function(command) {
  system(command, intern = FALSE)
}
