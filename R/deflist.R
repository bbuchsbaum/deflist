#' create a deferred list
#'
#' a read only list that retrieves elements with a function call
#'
#' @param fun the function that is used to retrieve elements
#' @param len the length of the list
#' @param names an optional set of names, 1 per element
#' @param memoise memoise function to speed up repeated element access
#' @export
#'
#' @import memoise
deflist <- function(fun, len=1, names, memoise=FALSE, cache=c("memory", "file"), cachedir=NULL) {
  assert_that(is.function(fun))
  cache <- rlang::arg_match(cache)
  #deferred_list(replicate(len, f))
  v <- vector(mode="list", length=len)
  if (!missing(names)) {
    assertthat::assert_that(length(names) == len)
    names(v) <- names
  }

  if (memoise) {
    cc <- if (cache == "memory") {
      cache_memory()
    } else if (cache == "file") {
      if (is.null(cachedir)) {
        cachedir <- tempdir()
        cache_filesystem(cachedir)
      } else {
        cache_filesystem(cachedir)
      }

    }

    fun <- memoise(fun, cache=cc)
    memoise::forget(fun)

  }

  structure(vector(mode="list", length=len), f=fun, len=len, memoised=memoise, cachedir=cachedir, class=c("deflist", "pairlist"))

}


#' @export
#' @method print deflist
print.deflist <- function(x,...) {
  cat("deflist: ", attr(x, "len"), " elements. \n")
  cat("memoised: ", attr(x, "memoised"), "\n")
  if (!is.null(attr(x, "cachedir"))) {
    cat("cache: ", attr(x, "cachedir"), "\n")
  }
}

#' @export
#' @method as.list deflist
as.list.deflist <- function(x,...) {
  purrr::map(seq(1,attr(x, "len")), ~ x[[.]])
}


#' @keywords internal
#' @export
`[[.deflist` <- function (x, i)  {
  #ff <- NextMethod()
  #ff(i)
  #stopifnot(i <= x$len)
  if (is.character(i)) {
    i <- match(i, names(x))
    if (is.na(i)) {
      NULL
    } else {
      attr(x, "f")(i)
    }
  } else {
    if (!(i <= attr(x, "len") && i > 0)) {
      rlang::abort(message="subscript out of bounds")
    } else {
        attr(x, "f")(i)
    }
  }
}

#' @keywords internal
`[.deflist` <- function (x, i)  {
  #ff <- NextMethod()
  #lapply(seq_along(i), function(j) x$f(i[j]))
  f <- attr(x, "f")
  lapply(seq_along(i), function(j) f(i[j]))
}

#' @keywords internal
`[[<-.deflist` <- function (x, i, value)  {
  rlang::abort(message="read only list, cannot set elements")
}

#' @keywords internal
`[<-.deflist` <- function (x, i, value)  {
  rlang::abort(message="read only list, cannot set elements")
}

#' @keywords internal
length.deflist <- function (x)  {
  #x$len
  attr(x, "len")
}

