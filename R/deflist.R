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
#' @examples
#' # Create a deferred list of squares
#' square_fun <- function(i) i^2
#' square_deflist <- deflist(square_fun, len = 5)
#' print(square_deflist)
#' cat("First element of the list:", square_deflist[[1]], "\n")
#' @export
deflist <- function(fun, len=1, names, memoise=FALSE, cache=c("memory", "file"), cachedir=NULL) {
  if (!is.function(fun)) {
    rlang::abort("`fun` must be a function.")
  }

  len <- .validate_deflist_length(len)
  cache <- rlang::arg_match(cache)

  if (!.is_single_flag(memoise)) {
    rlang::abort("`memoise` must be TRUE or FALSE.")
  }

  if (!is.null(cachedir) && !.is_single_string(cachedir)) {
    rlang::abort("`cachedir` must be NULL or a single file path.")
  }

  v <- vector(mode="list", length=len)

  if (!missing(names)) {
    if (!is.character(names) || length(names) != len) {
      rlang::abort("`names` must be a character vector with length equal to `len`.")
    }
    names(v) <- names
  }

  if (memoise) {
    cc <- if (cache == "memory") {
      memoise::cache_memory()
    } else {
      if (is.null(cachedir)) {
        cachedir <- tempdir()
      }
      memoise::cache_filesystem(cachedir)
    }

    fun <- memoise::memoise(fun, cache=cc)
    memoise::forget(fun)
  }

  structure(v, f=fun, len=len, memoised=memoise, cachedir=cachedir, class=c("deflist", "list"))
}

.is_single_flag <- function(x) {
  is.logical(x) && length(x) == 1L && !is.na(x)
}

.is_single_string <- function(x) {
  is.character(x) && length(x) == 1L && !is.na(x)
}

.validate_deflist_length <- function(len) {
  if (!is.numeric(len) || length(len) != 1L || is.na(len) || len < 0 || len != trunc(len)) {
    rlang::abort("`len` must be a single non-negative integer.")
  }

  as.integer(len)
}

.deflist_index_proxy <- function(x) {
  indices <- as.list(seq_len(attr(x, "len")))
  names(indices) <- names(x)
  indices
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
  f <- attr(x, "f")
  lapply(.deflist_index_proxy(x), function(i) f(i))
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
  if (length(i) != 1L) {
    rlang::abort("`[[` requires a single index or name.")
  }

  if (is.character(i)) {
    i <- match(i, names(x))
  }

  if (is.na(i)) {
    return(NULL)
  }

  if (!is.numeric(i) || i != trunc(i)) {
    rlang::abort("`[[` requires a whole-number index or a single name.")
  }

  if (!(i <= attr(x, "len") && i > 0)) {
    rlang::abort(message="subscript out of bounds")
  }

  attr(x, "f")(as.integer(i))
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
  if (missing(i)) {
    return(as.list(x))
  }

  f <- attr(x, "f")
  lapply(.deflist_index_proxy(x)[i], function(j) {
    if (is.null(j)) {
      NULL
    } else {
      f(j)
    }
  })
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
