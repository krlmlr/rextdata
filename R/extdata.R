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
