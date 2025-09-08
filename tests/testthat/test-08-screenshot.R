test_that("screenshot works", {
  chrome <- new_chromium()
  context <- chrome$new_context()$then()
  page <- context$new_page()$then()
  page$goto("https://playwright.dev/")$then()
  ss <- page$screenshot()$then()

  expect_no_condition(ss)
})
