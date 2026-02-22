# Retrieve the length of a deflist object

Retrieve the length of a deflist object

## Usage

``` r
# S3 method for class 'deflist'
length(x)
```

## Arguments

- x:

  A deflist object.

## Value

The length of the deflist object.

## Examples

``` r
square_fun <- function(i) i^2
square_deflist <- deflist(square_fun, len = 5)
stopifnot(length(square_deflist) == 5)
```
