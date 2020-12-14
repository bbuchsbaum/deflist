
<!-- README.md is generated from README.Rmd. Please edit that file -->

# deflist

<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/bbuchsbaum/deflist.svg?branch=master)](https://travis-ci.com/bbuchsbaum/deflist)
<!-- badges: end -->

The goal of `deflist` is to provide a list-like object for which element
access is routed through a user-supplied function. This can be used, for
example, when list-like syntax is required but one cannot afford to hold
all elements in memory at once.

## Installation

You can install the released version of `deflist` from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("deflist")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("bbuchsbaum/deflist")
```

## Examples

``` r

library(deflist)

dl <- deflist(function(i) i, len=10)
print(dl[[1]])
#> [1] 1

dl2 <- deflist(function(i) { Sys.sleep(5); i*2  }, len=10)

for (i in 1:10) {
  print(dl2[[i]])
}
#> [1] 2
#> [1] 4
#> [1] 6
#> [1] 8
#> [1] 10
#> [1] 12
#> [1] 14
#> [1] 16
#> [1] 18
#> [1] 20
```

The value at an index may change across calls, for example:

``` r
dl3 <- deflist(function(i) { rnorm(1) }, len=10)
print(dl3[[1]])
#> [1] 0.2362195
print(dl3[[1]])
#> [1] 1.249584
```

Memoisation can be enabled so that values at a given index are cached:

``` r
dl4 <- deflist(function(i) { rnorm(1)  }, len=10, memoise=TRUE)
print(dl4[[1]])
#> [1] -0.8104145
print(dl4[[1]])
#> [1] -0.8104145
```

In addition, memoisation can be set to store cached values to the file
system:

``` r
dl5 <- deflist(function(i) { rnorm(1000)  }, len=10, memoise=TRUE, cache="file", cachedir = tempdir())
print(dl5[[1]][1:10])
#>  [1]  0.31849112  0.82722265 -1.97761085 -0.42961918 -2.25089422 -0.02979399
#>  [7]  0.61559644 -1.29723046 -0.49598154 -0.51356279
print(dl5[[1]][1:10])
#>  [1]  0.31849112  0.82722265 -1.97761085 -0.42961918 -2.25089422 -0.02979399
#>  [7]  0.61559644 -1.29723046 -0.49598154 -0.51356279
```
