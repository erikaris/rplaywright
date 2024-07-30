test_that("new_page works", {
  chrome <- new_chromium()
  context <- chrome$new_context()
  page3 <- context$new_page(async = FALSE)

  expect_no_condition(context)
})
