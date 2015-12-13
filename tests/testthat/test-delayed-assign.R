context("Delayed assignment")

test_that("delayed assignment", {
  env <- new.env(parent = emptyenv())

  delayed_assign(fortytwo = 42L, message = { message("Hi!"); NULL },
                 assign.env = env)
  expect_identical(env$fortytwo, 42L)
  expect_message(env$message, "Hi!")
  expect_message(env$message, NA)

  delayed_assign_(~78L, assign.env = env)
  expect_identical(env$`78L`, 78L)
})
