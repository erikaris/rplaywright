test_that("new_context works", {
  chrome <- new_chromium()
  context <- chrome$new_context()

  expect_no_condition(context)
})
