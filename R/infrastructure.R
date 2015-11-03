#' Prepare a package for rextdata
#'
#' Adds the \code{rextdata} package to the \code{Imports} section of the
#' \code{DESCRIPTION}, creates a helper file that loads all external data
#' sets via \code{\link{auto_extdata}}, and converts all existing data sets
#' to \code{extdata} files.
#'
#' @inheritParams devtools::as.package
#' @param compress a logical specifying whether saving to a named file is to use
#'   \code{"gzip"} compression, or one of \code{"gzip"}, \code{"bzip2"} or
#'   \code{"xz"} to indicate the type of compression to be used.
use_rextdata <- function(compress = "xz", pkg = ".") {
  require_devtools()

  pkg <- devtools::as.package(pkg)

  devtools::use_package("rextdata", pkg = pkg)
  inst_extdata <- inst_extdata_path(pkg)
  dir.create(inst_extdata)
  data <- devtools::load_data(pkg)
  mapply(saveRDS, data, file.path(inst_extdata, paste0(names(data), ".rds")),
         MoreArgs = list(compress = compress))
  writeLines(
    "rextdata::auto_extdata()",
    file.path(pkg$path, "R", "aaa-rextdata.R"))
  message("* Created directory inst/extdata\n",
          if (length(data) > 0) {
            paste("* Saved datasets", paste(names(data), collapse = ", "), "as .rds files\n")
          },
          "* Created helper file R/aaa-rextdata.R\n",
          "Now include your datasets as .rds files in the inst/extdata directory.")
}

require_devtools <- function() {
  requireNamespace("devtools")
}
