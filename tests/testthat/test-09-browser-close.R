test_that("close works", {
  chrome <- new_chromium()
  resp <- chrome$close()$then()
  expect_no_condition(resp)
})
