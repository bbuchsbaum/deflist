# Changelog

## deflist 0.2.2

- Harden
  [`deflist()`](https://bbuchsbaum.github.io/deflist/reference/deflist.md)
  input validation so invalid lengths and malformed constructor
  arguments fail early.
- Align deferred-list subsetting more closely with base list behavior
  for logical, negative, missing, and `NA` indices.
- Tighten `[[.deflist` index validation to reject non-scalar and
  non-integer numeric inputs with clearer errors.
- Rework
  [`as.list.deflist()`](https://bbuchsbaum.github.io/deflist/reference/as.list.deflist.md)
  to preserve names while reducing allocation and dependency overhead.
- Drop unused imports and ignore generated `README.html` during package
  builds.

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
