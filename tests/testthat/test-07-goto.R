test_that("goto works", {
  chrome <- new_chromium()
  context <- chrome$new_context()
  page3 <- context$new_page(async = FALSE)
  page3$goto("https://playwright.dev/")

  expect_no_condition(context)
})
