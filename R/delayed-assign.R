#' Create a delayed assignment
#'
#' This function creates one or more delayed assignments in a more natural
#' way compared to \code{\link{delayedAssign}}.
#'
#' The "dots" argument can be named or unnamed; for unnamed arguments, names
#' will be assigned by \code{\link[lazyeval]{all_dots}}.  For each argument,
#' a delayed assignment with the specified name is created via
#' \code{\link{delayedAssign}}.  The delayed assignment will evaluate the
#' argument via \code{\link[lazyeval]{lazy_eval}}.
#'
#' The function \code{delayed_assign_} is a standard-evaluation version of the
#' above.  See the "lazyeval" vignette for details.
#'
#' @param ... Expressions for which delayed assignments are created.
#' @param .dots Expressions as lazy objects.
#' @param assign.env The environment in which to create the delayed assignments.
#'
#' @examples
#' \dontrun{
#' # Creates a delayed assignment "fortytwo" which takes about 7.5 million
#' # years to compute:
#' delayed_assign(fortytwo = { Sys.sleep(7.5e6 * 365 * 24 * 60 * 60); 42 })
#' }
#' @include lazyforward.R
"delayed_assign"

#' @export
#' @rdname delayed_assign
delayed_assign_ <- function(..., .dots, assign.env = parent.frame()) {
  dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)

  ret <- mapply(delayed_assign_one, names(dots), dots,
                MoreArgs = list(assign.env = assign.env))
  invisible(ret)
}

#' @export
delayed_assign <- lazyforward("delayed_assign_")


delayed_assign_one <- function(name, expr, assign.env = parent.frame()) {
  force(name)
  force(expr)
  delayedAssign(name, lazyeval::lazy_eval(expr), assign.env = assign.env)
  invisible(name)
}
