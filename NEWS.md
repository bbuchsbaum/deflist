# deflist 0.2.2

* Harden `deflist()` input validation so invalid lengths and malformed constructor arguments fail early.
* Align deferred-list subsetting more closely with base list behavior for logical, negative, missing, and `NA` indices.
* Tighten `[[.deflist` index validation to reject non-scalar and non-integer numeric inputs with clearer errors.
* Rework `as.list.deflist()` to preserve names while reducing allocation and dependency overhead.
* Drop unused imports and ignore generated `README.html` during package builds.

# deflist 0.2.1

* Fix `[[.deflist` to return `NULL` for missing names and `NA` indices without calling the retrieval function.
* Fix `as.list.deflist()` for zero-length deferred lists.
* Fix character subsetting (`[.deflist`) to preserve names and missing names (`NA`) consistently with base lists.
* Add regression tests for missing-name access, `NA` index access, zero-length `as.list()`, and constructor name-length validation.

# deflist 0.2.0

# deflist 0.1.0

* Added a `NEWS.md` file to track changes to the package.
