# Create a deferred list

A read-only list that retrieves elements with a function call. The
deferred list is useful for handling large datasets where elements are
computed on-demand.

## Usage

``` r
deflist(
  fun,
  len = 1,
  names,
  memoise = FALSE,
  cache = c("memory", "file"),
  cachedir = NULL
)
```

## Arguments

- fun:

  A function that is used to retrieve elements.

- len:

  Integer, the length of the list (default is 1).

- names:

  Character vector, an optional set of names, one per element.

- memoise:

  Logical, whether to memoise the function to speed up repeated element
  access (default is FALSE).

- cache:

  Character, use an in-memory or filesystem cache if `memoise` is TRUE
  (default is "memory").

- cachedir:

  Character, the file path to the cache (default is NULL).

## Value

An object of class "deflist" representing the deferred list.

## Details

The deferred list is created using the provided function, length, names,
and caching options. The list is read-only, and elements are retrieved
using the provided function.

## Examples

``` r
# Create a deferred list of squares
square_fun <- function(i) i^2
square_deflist <- deflist(square_fun, len = 5)
print(square_deflist)
#> deflist:  5  elements. 
#> memoised:  FALSE 
cat("First element of the list:", square_deflist[[1]], "\n")
#> First element of the list: 1 
```
