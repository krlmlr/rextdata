Version 0.0-6 (2015-12-13)
===

- Fix loading unnamed RDS files for more than one file.


Version 0.0-5 (2015-12-13)
===

- Raise error if `devtools` is required but not available.
- New `read_rds()`.
- New `delayed_assign()`.


Version 0.0-4 (2015-12-13)
===

- Use private copy of lazyforward code to speed up CRAN release.
- Use autoroxy.
- Satisfy R CMD check.
- Add testing infrastructure.


0.0-3
=====

- Fix `use_rextdata()`; will delete `data/` subdirectory
- `use_extdata()` gains `env` argument

0.0-2
=====

- Export functions
- New `use_extdata()` and `use_rextdata()` to simplify creation of data and migration

0.0-1
=====

- Initial release
