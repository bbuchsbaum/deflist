% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/deflist.R
\name{deflist}
\alias{deflist}
\title{create a deferred list}
\usage{
deflist(
  fun,
  len = 1,
  names,
  memoise = FALSE,
  cache = c("memory", "file"),
  cachedir = NULL
)
}
\arguments{
\item{fun}{the function that is used to retrieve elements}

\item{len}{the length of the list}

\item{names}{an optional set of names, 1 per element}

\item{memoise}{memoise function to speed up repeated element access}

\item{cache}{use an in-memory or filesystem cache (if \code{memoise} is \code{TRUE})}

\item{cachedir}{the file path to the cache}
}
\description{
a read only list that retrieves elements with a function call
}
