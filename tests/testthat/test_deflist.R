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


