#' Prepare a package for rextdata
#'
#' Adds the \code{rextdata} package to the \code{Imports} section of the
#' \code{DESCRIPTION}, creates a helper file that loads all external data
#' sets via \code{\link{auto_extdata}}, and converts all existing data sets
#' to \code{extdata} files.
#'
#' @inheritParams devtools::load_all
#' @inheritParams use_extdata
#' @export
use_rextdata <- function(compress = "xz", pkg = ".", overwrite = FALSE) {
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

  loaded <- devtools::load_all(pkg)

  use_extdata_(.dots = loaded$data, pkg = pkg, compress = compress,
               overwrite = overwrite, env = loaded$env)

  message("* Removed data directory")
  unlink(file.path(pkg$path, "data"), recursive = TRUE)

  message("Now include additional datasets as .rds files in the inst/extdata directory.")
}

#' Use an object as external dataset
#' @template se
#' @export
#' @templateVar name use_extdata
use_extdata_ <- function(..., .dots, pkg = ".", compress = "xz",
                         overwrite = FALSE, env = parent.frame())
{
  dots <- lazyeval::all_dots(.dots, ..., all_named = TRUE)

  if (length(dots) == 0L) return()

  require_devtools()

  pkg <- devtools::as.package(pkg)

  inst_extdata <- inst_extdata_path(pkg)

  files <- file.path(inst_extdata, paste0(names(dots), ".rds"))
  if (!overwrite && any(file.exists(files))) {
    stop("At least one of the target files exists. Use overwrite = TRUE to override.",
         call. = FALSE)
  }

  mapply(
    function(dot, file) {
      object <- lazyeval::lazy_eval(dot, env)
      saveRDS(object, file, compress = compress)
    },
    dots, files)

  message("* Saved datasets ", paste(names(dots), collapse = ", "),
          " to ", inst_extdata)
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
#' @param overwrite overwrite existing files?
#' @param env the environment in which to evaluate the expressions
#' @inheritParams use_rextdata
#' @export
use_extdata <- lazyforward::lazyforward("use_extdata_")

require_devtools <- function() {
  requireNamespace("devtools")
}
