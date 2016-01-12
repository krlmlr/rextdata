context("Infrastructure")

test_that("use_rextdata", {
  package_dir <- tempfile("pkg")
  expect_output(devtools::create(package_dir), ".")
  pkg <- devtools::as.package(package_dir)
  fortytwo <- 42
  devtools::use_data(fortytwo, pkg = pkg)
  expect_true(file.exists(file.path(package_dir, "data/fortytwo.rda")))
  rm(fortytwo)

  devtools::load_all(pkg)
  on.exit(devtools::unload(pkg))

  expect_identical(fortytwo, 42)

  use_rextdata(pkg = pkg)
  expect_false(file.exists(file.path(package_dir, "data/fortytwo.rda")))
  expect_true(file.exists(file.path(package_dir, "inst/extdata/fortytwo.rds")))

  devtools::load_all(pkg)

  expect_identical(fortytwo, 42)
})
