test_that("goto works", {
  chrome <- new_chromium()
  context <- chrome$new_context()$then()
  page <- context$new_page()$then()
  resp <- page$goto("https://playwright.dev/")$then()

  expect_no_condition(resp)
})
