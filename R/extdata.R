extdata_path <- function(package.env = assign.env) {
  system.file("extdata", package = packageName(package.env))
}

extdata <- function(name, assign.env = parent.frame()) {
  name_ <- deparse(substitute(name, env = assign.env))
  extdata_(name_, assign.env = assign.env)
}

extdata_ <- function(name, assign.env = parent.frame()) {
  force(name)
  file_path <- file.path(extdata_path(assign.env), paste0(name, ".rds"))
  delayedAssign(name, { message("Loading ", file_path); readRDS(file_path) }, assign.env = assign.env)
  invisible(name)
}

auto_extdata() <- function(assign.env = parent.frame()) {
  extension_pattern <- "[.]rds$"
  files <- dir(extdata_path(assign.env), pattern = extension_pattern)
  names <- gsub(extension_pattern, "", files)
  vapply(names, extdata_, assign.env = assign.env, character(1L))
}
