#' Prepare a package for rextdata
#'
#' Adds the \code{rextdata} package to the \code{Imports} section of the
#' \code{DESCRIPTION}, creates a helper file that loads all external data
#' sets via \code{\link{auto_extdata}}, and converts all existing data sets
#' to \code{extdata} files.
#'
#' @inheritParams devtools::as.package
#' @inheritParams use_extdata
#' @export
use_rextdata <- function(compress = "xz", pkg = ".") {
  require_devtools()

  pkg <- devtools::as.package(pkg)

  devtools::use_package("rextdata", pkg = pkg)

  inst_extdata <- inst_extdata_path(pkg)
  if (!file.exists(inst_extdata)) {
    dir.create(inst_extdata, recursive = TRUE, showWarnings = FALSE)
    message("* Created directory inst/extdata")
  }

  auto_extdata <- file.path("R", "aaa-rextdata.R")
  auto_extdata_path <- file.path(pkg$path, auto_extdata)
  if (!file.exists(auto_extdata)) {
    writeLines("rextdata::auto_extdata()", auto_extdata_path)
    message("* Created helper file ", auto_extdata)
  }

  use_extdata_(.dots = devtools::load_data(pkg), pkg = pkg, compress = compress)

  message("Now include your datasets as .rds files in the inst/extdata directory.")
}

#' Use an object as external dataset
#' @template se
#' @templateVar name extdata
#' @export
use_extdata_ <- function(..., .dots, compress = "xz", pkg = ".") {
  dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)

  if (length(dots) == 0L) return()

  require_devtools()

  pkg <- devtools::as.package(pkg)

  inst_extdata <- inst_extdata_path(pkg)

  mapply(
    function(dot, file) {
      saveRDS(lazyeval::lazy_eval(dot), file, compress = compress)
    },
    dots,
    file.path(inst_extdata, paste0(names(dots), ".rds")))

  message("* Saved datasets ", paste(names(dots), collapse = ", "),
          " to ")
}

#' Use an object as external dataset
#'
#' Call this function to save an object as \code{.rds} file in the
#' \code{inst/extdata} directory for later retrieval via \code{\link{extdata}}
#' or \code{\link{auto_extdata}}.
#'
#'
#' @param ... objects to save in \code{name} or \code{name = value} format
#' @param compress a logical specifying whether saving to a named file is to use
#'   \code{"gzip"} compression, or one of \code{"gzip"}, \code{"bzip2"} or
#'   \code{"xz"} to indicate the type of compression to be used.
#' @inheritParams use_rextdata
#' @export
use_extdata <- lazyforward::lazyforward("use_extdata_")

require_devtools <- function() {
  requireNamespace("devtools")
}
