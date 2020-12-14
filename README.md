
<!-- README.md is generated from README.Rmd. Please edit that file -->

# deflist

<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/bbuchsbaum/deflist.svg?branch=master)](https://travis-ci.com/bbuchsbaum/deflist)
<!-- badges: end -->

The goal of deflist is to …

## Installation

You can install the released version of deflist from
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
#> [1] -1.663331
print(dl3[[1]])
#> [1] -0.2304031
```

Memoisation can be enabled so that values at a given index are cached:

``` r
dl4 <- deflist(function(i) { rnorm(1)  }, len=10, memoise=TRUE)
print(dl4[[1]])
#> [1] 0.4325363
print(dl4[[1]])
#> [1] 0.4325363
```

In addition, memoisation can be set to store cached values to the file
system:

``` r
dl5 <- deflist(function(i) { rnorm(1000)  }, len=10, memoise=TRUE, cache="file", cachedir = tempdir())
print(dl5[[1]][1:10])
#>  [1] -0.33732790 -0.02889099  0.80109000 -0.39395217  0.72064623  0.48999737
#>  [7]  0.44865191  0.15336727 -0.51116197 -0.41759692
print(dl5[[1]][1:10])
#>  [1] -0.33732790 -0.02889099  0.80109000 -0.39395217  0.72064623  0.48999737
#>  [7]  0.44865191  0.15336727 -0.51116197 -0.41759692
```
