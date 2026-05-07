if (!exists("convert_files", mode = "function")) {
  root_dir <- normalizePath(file.path("..", ".."))
  sys.source(file.path(root_dir, "R", "internal_helpers.R"), envir = globalenv())
  sys.source(file.path(root_dir, "R", "convert_files.R"), envir = globalenv())
  sys.source(file.path(root_dir, "R", "get_pwiz_container.R"), envir = globalenv())
  sys.source(file.path(root_dir, "R", "zzz.R"), envir = globalenv())
}

pkg_env <- function() {
  environment(convert_files)
}

local_rebind <- function(env, bindings) {
  binding_names <- names(bindings)
  present <- vapply(binding_names, exists, logical(1), envir = env, inherits = FALSE)
  old_bindings <- lapply(binding_names, function(name) {
    if (exists(name, envir = env, inherits = FALSE)) {
      get(name, envir = env, inherits = FALSE)
    } else {
      NULL
    }
  })
  names(old_bindings) <- binding_names
  locked <- vapply(
    binding_names,
    function(name) exists(name, envir = env, inherits = FALSE) && bindingIsLocked(name, env),
    logical(1)
  )

  for (name in binding_names) {
    if (exists(name, envir = env, inherits = FALSE) && bindingIsLocked(name, env)) {
      unlockBinding(name, env)
    }
    assign(name, bindings[[name]], envir = env)
  }

  withr::defer(
    {
      for (idx in seq_along(binding_names)) {
        name <- binding_names[[idx]]
        if (exists(name, envir = env, inherits = FALSE) && bindingIsLocked(name, env)) {
          unlockBinding(name, env)
        }
        if (present[[idx]]) {
          assign(name, old_bindings[[name]], envir = env)
        } else {
          rm(list = name, envir = env)
        }
        if (locked[[idx]] && exists(name, envir = env, inherits = FALSE)) {
          lockBinding(name, env)
        }
      }
    },
    envir = parent.frame()
  )
}

local_raw_file <- function(path, contents = "raw") {
  writeLines(contents, path)
  path
}
