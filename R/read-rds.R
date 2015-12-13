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
  if (length(x) == 0L) return()
  gsub("[.]rds$", "", basename(x))
}
