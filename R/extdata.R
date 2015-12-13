#' Create a delayed assignment for a dataset
#'
#' This function creates one or more delayed assignments, focusing on data
#' stored in the \code{extdata} directory, and therefore especially useful for
#' package development.  The main advantage over R's internal data loading
#' mechanism is faster package build time.
#'
#' The "dots" argument can be named or unnamed; for unnamed arguments, names
#' will be assigned by \code{\link[lazyeval]{all_dots}}.  The name of the
#' RDS file is derived from the argument name and passed over to
#' \code{\link{read_rds}}.
#'
#' @param ... Base names for RDS files.
#' @param .dots Base names for RDS files as lazy objects.
#' @param assign.env The environment in which to create the delayed assignments.
#'
#' @examples
#' \dontrun{
#' # Creates a delayed assignment "fortytwo" which loads the file
#' # "extdata/fortytwo.rds"
#' extdata(fortytwo)
#' }
#' @include lazyforward.R
"extdata"

#' @export
#' @rdname extdata
extdata_ <- function(..., .dots, assign.env = parent.frame()) {
  dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)

  dots_expr <- vapply(
    dots,
    function(dot) {
      file.path(extdata_path(assign.env),
                paste0(as.character(dot$expr), ".rds"))
    },
    character(1L))

  read_rds(dots_expr, assign.env = assign.env)
}

#' @export
extdata <- lazyforward("extdata_")


#' Create delayed assignments for all datasets in a package
#'
#' This function lists all \code{.rds} files in the \code{extdata/} directory
#' and calls \code{\link{read_rds}}.  This offers an easy method to
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
