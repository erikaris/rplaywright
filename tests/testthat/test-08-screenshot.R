test_that("screenshot works", {
  chrome <- new_chromium()
  context <- chrome$new_context()
  page3 <- context$new_page(async = FALSE)
  page3$goto("https://playwright.dev/")
  ss3 <- page3$screenshot()

  expect_no_condition(ss3)
})
