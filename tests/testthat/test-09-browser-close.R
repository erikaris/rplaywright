test_that("close works", {
  chrome <- new_chromium()
  expect_no_condition(chrome$close())
})
