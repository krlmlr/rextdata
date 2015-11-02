extdata_path <- function(package.env = assign.env) {
  system.file("extdata", package = packageName(package.env))
}

extdata <- function(..., assign.env = parent.frame()) {
  extdata_(.dots = lazyeval::lazy_dots(...), assign.env = assign.env)
}

extdata_ <- function(..., .dots, assign.env = parent.frame()) {
  dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)

  dots_expr <- lapply(
    dots,
    function(dot) {
      if (is.name(dot$expr)) {
        file_path <- file.path(extdata_path(assign.env), paste0(as.character(dot$expr), ".rds"))
        bquote(readRDS(.(file_path)))
      } else
        dot$expr
  })

  ret <- mapply(extdata_one, names(dots_expr), dots_expr, MoreArgs = list(assign.env = assign.env))
  invisible(ret)
}

extdata_one <- function(name, expr, assign.env = parent.frame()) {
  delayedAssign(name, eval(expr), assign.env = assign.env)
  invisible(name)
}

auto_extdata <- function(assign.env = parent.frame()) {
  extension_pattern <- "[.]rds$"
  files <- dir(extdata_path(assign.env), pattern = extension_pattern)
  names <- gsub(extension_pattern, "", files)
  extdata_(.dots = names, assign.env = assign.env)
}
