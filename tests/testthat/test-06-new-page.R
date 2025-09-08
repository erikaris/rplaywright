test_that("new_page works", {
  chrome <- new_chromium()
  context <- chrome$new_context()$then()
  page <- context$new_page()$then()

  expect_no_condition(page)
})
