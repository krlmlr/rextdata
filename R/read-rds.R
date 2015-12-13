#' Delay-load an RDS file
#'
#' This function creates one or more delayed assignments that load RDS files
#' (via \code{\link{readRDS}}). For unnamed arguments, names are derived
#' from the basename of the RDS files.  Paths are normalized (via
#' \code{\link{normalizePath}}); a warning is thrown if the file
#' does not exist.
#'
#' @param ... Paths to RDS files.
#' @param assign.env The environment in which to create the delayed assignments.
#'
#' @examples
#' \dontrun{
#' # Creates a delayed assignment "fortytwo" which loads the file
#' # "extdata/fortytwo.rds"
#' read_rds(fortytwo = system.file("extdata", "fortytwo.rds"))
#' }
#' @export
read_rds <- function(..., assign.env = parent.frame()) {
  dots <- c(...)
  if (length(dots) == 0L) {
    return()
  }
  unnamed <- (names(dots) == "")
  if (length(unnamed) == 0L) {
    unnamed <- TRUE
  }

  names(dots)[unnamed] <- name_from_rds(dots[unnamed])

  dots_expr <- lapply(
    dots,
    function(dot) {
      dot <- normalizePath(dot)
      bquote(readRDS(.(dot)))
  })

  delayed_assign_(.dots = dots_expr, assign.env = assign.env)
}

name_from_rds <- function(x) {
  gsub("[.]rds$", "", basename(x))
}


#' Create delayed assignments for all datasets in a package
#'
#' This function lists all \code{.rds} files in the \code{extdata/} directory
#' and calls \code{\link{read_rds_}} for each.  This offers an easy method to
#' simulate R's lazy-loading mechanism for data: Place all datasets in
#' individual \code{.rds} files in \code{extdata/}, and call this function
#' somewhere in your package's source files.
#'
#' @inheritParams read_rds
#' @examples
#' \dontrun{
#' auto_extdata()
#' }
#' @export
auto_extdata <- function(assign.env = parent.frame()) {
  extension_pattern <- "[.]rds$"
  files <- dir(extdata_path(assign.env), pattern = extension_pattern,
               full.names = TRUE)

  read_rds(files, assign.env = assign.env)
}

extdata_name <- function() c("extdata", file.path("inst", "extdata"))

extdata_path <- function(package.env) {
  system.file(extdata_name(), package = packageName(package.env))[[1L]]
}

inst_extdata_path <- function(pkg) {
  file.path(pkg$path, extdata_name()[[2L]])
}
