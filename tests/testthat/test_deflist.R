
library(testthat)
library(deflist)


test_that("can create a 1 element deflist", {
  dl <- deflist(function(i) 2, len=1)
  expect_equal(dl[[1]],2)
  expect_error(dl[[2]])
  expect_error(dl[[0]])
  expect_error(dl[2])
})

test_that("can create a multielement deflist", {
  dl <- deflist(function(i) i, len=10)
  expect_equal(dl[[1]],1)
  expect_equal(dl[[10]],10)
  expect_equal(dl[1:2], list(1,2)[1:2])
})

test_that("can create a memoised deflist", {
  dl <- deflist(function(i) i, len=10, memoise=TRUE)
  dl2 <- deflist(function(i) i, len=10, memoise=FALSE)
  for (i in 1:10) {
    expect_equal(dl[[i]],dl2[[i]])
  }
})


test_that("deflist creation works", {
  square_fun <- function(i) i^2
  square_deflist <- deflist(square_fun, len = 5)

  expect_s3_class(square_deflist, "deflist")
  expect_length(square_deflist, 5)
  expect_true(is.list(square_deflist))
})

test_that("deflist access works", {
  square_fun <- function(i) i^2
  square_deflist <- deflist(square_fun, len = 5)

  expect_equal(square_deflist[[1]], 1)
  expect_equal(square_deflist[[3]], 9)
  expect_equal(square_deflist[[5]], 25)
})

test_that("deflist subsetting works", {
  square_fun <- function(i) i^2
  square_deflist <- deflist(square_fun, len = 5)

  subset <- square_deflist[c(1, 3, 5)]
  expect_equal(subset, list(1, 9, 25))
})

test_that("deflist named access works", {
  square_fun <- function(i) i^2
  square_deflist <- deflist(square_fun, len = 3, names = c("one", "two", "three"))

  expect_equal(square_deflist[["one"]], 1)
  expect_equal(square_deflist[["two"]], 4)
  expect_equal(square_deflist[["three"]], 9)
})

test_that("deflist assignment error", {
  square_fun <- function(i) i^2
  square_deflist <- deflist(square_fun, len = 5)

  expect_error(square_deflist[[1]] <- 10, "read only list, cannot set elements")
  expect_error(square_deflist[1] <- 10, "read only list, cannot set elements")
})

test_that("deflist out of bounds error", {
  square_fun <- function(i) i^2
  square_deflist <- deflist(square_fun, len = 5)

  expect_error(square_deflist[[6]], "subscript out of bounds")
})

test_that("deflist memoisation works", {
  count <- 0
  square_fun <- function(i) {
    count <<- count + 1
    i^2
  }
  square_deflist <- deflist(square_fun, len = 5, memoise = TRUE)

  expect_equal(square_deflist[[1]], 1)
  expect_equal(square_deflist[[1]], 1)
  expect_equal(count, 1)
})

test_that("deflist as.list works", {
  square_fun <- function(i) i^2
  square_deflist <- deflist(square_fun, len = 5)

  square_list <- as.list(square_deflist)
  expect_equal(square_list, list(1, 4, 9, 16, 25))
})

test_that("deflist print works", {
  square_fun <- function(i) i^2
  square_deflist <- deflist(square_fun, len = 5)

  output <- capture.output(print(square_deflist))
  expect_true(grepl("deflist", output[1]))
  expect_true(grepl("5  elements", output[1]))
})

test_that("deflist file cache works", {
  square_fun <- function(i) i^2
  square_deflist <- deflist(square_fun, len = 5, memoise = TRUE, cache = "file", cachedir = tempdir())

  expect_equal(square_deflist[[1]], 1)
  expect_equal(square_deflist[[2]], 4)
  expect_equal(square_deflist[[3]], 9)
  expect_equal(square_deflist[[4]], 16)
  expect_equal(square_deflist[[5]], 25)

  # Check that the cache directory is set
  output <- capture.output(print(square_deflist))
  expect_true(grepl("cache", output[3]))
})

# test_that("deflist missing cache dir uses tempdir()", {
#   square_fun <- function(i) i^2
#   square_deflist <- deflist(square_fun, len = 5, memoise = TRUE, cache = "file")
#
#   expect_equal(square_deflist[[1]], 1)
#   expect_equal(square_deflist[[2]], 4)
#   expect_equal(square_deflist[[3]], 9)
#   expect_equal(square_deflist[[4]], 16)
#   expect_equal(square_deflist[[5]], 25)
#
#   # Check that the cache directory is set to tempdir()
#   output <- capture.output(print(square_deflist))
#   expect_true(grepl(tempdir(), output[3]))
# })






