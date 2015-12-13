context("Reading RDS files")


test_that("read_rds() works and uses correct directory", {
  env <- new.env(parent = emptyenv())

  read_rds(file.path("extdata", "fortytwo.rds"), assign.env = env)
  withr::with_dir(
    tempdir(),
    expect_identical(env$fortytwo, 42)
  )
})
