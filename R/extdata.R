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
#' The function \code{extdata_} is a standard-evaluation version of the
#' above.  See the "lazyeval" vignette for details.
#'
#' @param ... Expressions for which delayed assignments are created.
#' @param .dots Expressions as lazy objects.
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
