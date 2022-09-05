test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

b <- bristler::bristle_sample

test_that("plot_freq works", {
  p <- bristler::plot_bristle_freq(head(b))
  expect_equal(p$data$sum[1], 0.2629591, tolerance = 0.001 )
})
