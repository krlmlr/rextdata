# rextdata

Easy access to datasets placed in the `extdata` folder. Currently, creates a delayed assignment for each `.rds` file (via `auto_extdata()`). Arbitrary files are supported in `read_rds()`, arbitrary expressions in `delayed_assign()`.  Use `use_extdata()` to add a dataset to a package the same way as you would use `devtools::use_data()`.
