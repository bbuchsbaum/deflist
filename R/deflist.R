#' Create a deferred list
#'
#' A read-only list that retrieves elements with a function call.
#' The deferred list is useful for handling large datasets where elements are computed on-demand.
#'
#' @param fun A function that is used to retrieve elements.
#' @param len Integer, the length of the list (default is 1).
#' @param names Character vector, an optional set of names, one per element.
#' @param memoise Logical, whether to memoise the function to speed up repeated element access (default is FALSE).
#' @param cache Character, use an in-memory or filesystem cache if `memoise` is TRUE (default is "memory").
#' @param cachedir Character, the file path to the cache (default is NULL).
#'
#' @return An object of class "deflist" representing the deferred list.
#'
#' @details The deferred list is created using the provided function, length, names, and caching options.
#'          The list is read-only, and elements are retrieved using the provided function.
#'
#' @import memoise
#' @import assertthat
#' @importFrom rlang arg_match
#' @importFrom purrr map
#'
#' @examples
#' # Create a deferred list of squares
#' square_fun <- function(i) i^2
#' square_deflist <- deflist(square_fun, len = 5)
#' print(square_deflist)
#' cat("First element of the list:", square_deflist[[1]], "\n")
#' @export
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

#' Convert a deflist object to a list
#'
#' @param x A deflist object.
#' @param ... Additional arguments passed to methods.
#'
#' @return A list containing the elements of the deflist object.
#'
#' @export
#' @method as.list deflist
as.list.deflist <- function(x,...) {
  purrr::map(seq(1,attr(x, "len")), ~ x[[.]])
}


#' Retrieve an element from a deflist object
#'
#' @param x A deflist object.
#' @param i Index or name of the element to be retrieved.
#'
#' @return The element at the specified index or name in the deflist object.
#'
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

## old
# `[.deflist` <- function (x, i)  {
#   if (is.character(i)) {
#     ind <- match(i, names(x))
#     ret <- lapply(ind, function(j) x[[j]])
#     nam <- ifelse(!is.na(ind), ind, "<NA>")
#     names(ret) <- nam
#     ret
#   } else {
#     f <- attr(x, "f")
#     ret <- lapply(seq_along(i), function(j) x[[i[j]]])
#     if (!is.null(names(x))) {
#       names(ret) <- names(x)[i]
#     }
#     ret
#   }
# }


#' Subset a deflist object
#'
#' @param x A deflist object.
#' @param i Indices or names of the elements to be retrieved.
#'
#' @return A list containing the elements at the specified indices or names in the \code{deflist} object.
#' @export
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




#' Prevent assignment to an element in a deflist object
#'
#' @param x A deflist object.
#' @param i Index or name of the element to be assigned.
#' @param value Value to be assigned to the element.
#'
#' @return this function throws an error be design, no return value
#'
#' @export
`[[<-.deflist` <- function (x, i, value)  {
  rlang::abort(message="read only list, cannot set elements")
}

#' Prevent assignment to elements in a deflist object
#'
#' @param x A deflist object.
#' @param i Indices or names of the elements to be assigned.
#' @param value Values to be assigned to the elements.
#'
#' @return this function throws an error be design, no return value
#'
#' @export
`[<-.deflist` <- function (x, i, value)  {
  rlang::abort(message="read only list, cannot set elements")
}


#' Retrieve the length of a deflist object
#'
#' @param x A deflist object.
#'
#' @return The length of the deflist object.
#' @examples
#' square_fun <- function(i) i^2
#' square_deflist <- deflist(square_fun, len = 5)
#' stopifnot(length(square_deflist) == 5)
#'
#' @export
length.deflist <- function (x)  {
  #x$len
  attr(x, "len")
}

