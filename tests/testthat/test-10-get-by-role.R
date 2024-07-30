test_that("screenshot works", {
  chrome <- new_chromium(start_server = F)
  context <- chrome$new_context()
  page3 <- context$new_page(async = FALSE)
  page3$goto("https://playwright.dev/")
  ss3 <- page3$get_by_role("link", options=list(name="Get started"))

  expect_no_condition(ss3)
})
