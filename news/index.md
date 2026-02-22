# Changelog

## deflist 0.2.1

- Fix `[[.deflist` to return `NULL` for missing names and `NA` indices
  without calling the retrieval function.
- Fix
  [`as.list.deflist()`](https://bbuchsbaum.github.io/deflist/reference/as.list.deflist.md)
  for zero-length deferred lists.
- Fix character subsetting (`[.deflist`) to preserve names and missing
  names (`NA`) consistently with base lists.
- Add regression tests for missing-name access, `NA` index access,
  zero-length [`as.list()`](https://rdrr.io/r/base/list.html), and
  constructor name-length validation.

## deflist 0.2.0

CRAN release: 2023-04-27

## deflist 0.1.0

- Added a `NEWS.md` file to track changes to the package.
