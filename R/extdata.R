extdata_path <- function(assign.env = assign.env) {
  system.file("extdata", package = packageName(assign.env))
}

lazydata <- function(name, assign.env = parent.frame()) {
  name_ <- deparse(substitute(name, env = assign.env))
  lazydata_(name_, assign.env = assign.env)
}

lazydata_ <- function(name, assign.env = parent.frame()) {
  force(name)
  file_path <- file.path(extdata_path(assign.env), paste0(name, ".rds"))
  delayedAssign(name, { message("Loading ", file_path); readRDS(file_path) }, assign.env = assign.env)
  invisible(name)
}

all_lazy <- function(assign.env = parent.frame()) {
  extension_pattern <- "[.]rds$"
  files <- dir(extdata_path(assign.env), pattern = extension_pattern)
  names <- gsub(extension_pattern, "", files)
  vapply(names, lazydata_, assign.env = assign.env, character(1L))
}
