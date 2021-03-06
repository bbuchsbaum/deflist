#' create a deferred list
#'
#' a read only list that retrieves elements with a function call
#'
#' @param fun the function that is used to retrieve elements
#' @param len the length of the list
#' @param names an optional set of names, 1 per element
#' @param memoise memoise function to speed up repeated element access
#' @param cache use an in-memory or filesystem cache (if `memoise` is \code{TRUE})
#' @param cachedir the file path to the cache
#' @export
#'
#' @import memoise
#' @import assertthat
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
        memoise::cache_filesystem(cachedir)
      } else {
        memoise::cache_filesystem(cachedir)
      }

    }

    fun <- memoise::memoise(fun, cache=cc)
    memoise::forget(fun)

  }

  structure(v, f=fun, len=len, memoised=memoise, cachedir=cachedir, class=c("deflist", "list"))

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
    attr(x, "f")(i)
  } else if (is.na(i)) {
    NULL
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
  if (is.character(i)) {
    ind <- match(i, names(x))
    ret <- lapply(ind, function(j) x[[j]])
    nam <- ifelse(!is.na(ind), ind, "<NA>")
    names(ret) <- nam
    ret
  } else {
    f <- attr(x, "f")
    ret <- lapply(seq_along(i), function(j) x[[i[j]]])
    if (!is.null(names(x))) {
      names(ret) <- names(x)[i]
    }
    ret
  }
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

