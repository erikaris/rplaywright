test_that("screenshot works", {
  chrome <- new_chromium()
  context <- chrome$new_context()$then()
  page <- context$new_page()$then()
  page$goto("https://playwright.dev/")$then()
  locator <- page$get_by_role("link", list(name="Get started"))$first()
  text_content <- locator$text_content()$then()

  expect_equal(text_content, "Get started")
})
