
b <- bristler::bristle_sample

test_that("plot_freq works", {
  p <- bristler::plot_bristle_freq(head(b))
  expect_equal(p$data$sum[1], 0.2629591, tolerance = 0.001 )
})

test_that("treemap works", {
  t <- bristler::treemap_of_sample(b)
  expect_equal(as.character(t[5,1]), "Bacillus")
})
