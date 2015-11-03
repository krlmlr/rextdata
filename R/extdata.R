#' Create a delayed assignment for a dataset
#' @template se
#' @export
#' @templateVar name extdata
extdata_ <- function(..., .dots, assign.env = parent.frame()) {
  dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)

  dots_expr <- lapply(
    dots,
    function(dot) {
      if (is.name(dot$expr)) {
        file_path <- file.path(extdata_path(assign.env), paste0(as.character(dot$expr), ".rds"))
        dot$expr <- bquote(readRDS(.(file_path)))
      }

      dot
  })

  ret <- mapply(extdata_one, names(dots_expr), dots_expr, MoreArgs = list(assign.env = assign.env))
  invisible(ret)
}

#' Create a delayed assignment for a dataset
#'
#' This function creates one or more delayed assignments.  It is focused on data
#' stored in the \code{extdata} directory, and therefore especially useful for
#' package development.  The main advantages over R's internal data loading
#' mechanism are faster package build times; the delayed assignment makes sure
#' that the data is loaded only if necessary.
#'
#' The "dots" argument can be named or unnamed; for unnamed arguments, names
#' will be assigned by \code{\link[lazyeval]{all_dots}}.  For each argument,
#' a delayed assignment with the specified name is created via
#' \code{\link{delayedAssign}}.  The delayed assignment will evaluate the
#' argument; if the argument is a single name, the corresponding \code{.rds}
#' data file from the \code{extdata} directory will be loaded.
#'
#' The function \code{\link{extdata_}} is a standard-evaluation version of the
#' above.  See the "lazyeval" vignette for details.
#'
#' @param ... Expressions for which delayed assignments are created.
#' @param assign.env The environment in which to create the delayed assignments.
#'
#' @examples
#' \dontrun{
#' # Creates a delayed assignment "fortytwo" which loads the file
#' # "extdata/fortytwo.rds"
#' extdata(fortytwo = readRDS(system.file("extdata", "fortytwo.rds",
#'         package = "mypackage")))
#' # A shorter version of the above
#' extdata(fortytwo)
#' }
#' @export
extdata <- lazyforward::lazyforward("extdata_")


extdata_one <- function(name, expr, assign.env = parent.frame()) {
  force(name)
  force(expr)
  delayedAssign(name, lazyeval::lazy_eval(expr), assign.env = assign.env)
  invisible(name)
}

#' Create delayed assignments for all datasets in a package
#'
#' This function lists all \code{.rds} files in the \code{extdata/} directory
#' and calls \code{\link{extdata_}} for each.  This offers an easy method to
#' simulate R's lazy-loading mechanism for data: Place all datasets in
#' individual \code{.rds} files in \code{extdata/}, and call this function
#' somewhere in your package's source files.
#'
#' @inheritParams extdata
#' @examples
#' \dontrun{
#' auto_extdata()
#' }
#' @export
auto_extdata <- function(assign.env = parent.frame()) {
  extension_pattern <- "[.]rds$"
  files <- dir(extdata_path(assign.env), pattern = extension_pattern)
  names <- gsub(extension_pattern, "", files)
  extdata_(.dots = names, assign.env = assign.env)
}

extdata_name <- function() c("extdata", file.path("inst", "extdata"))

extdata_path <- function(package.env) {
  system.file(extdata_name(), package = packageName(package.env))[[1L]]
}

inst_extdata_path <- function(pkg) {
  file.path(pkg$path, extdata_name()[[2L]])
}
