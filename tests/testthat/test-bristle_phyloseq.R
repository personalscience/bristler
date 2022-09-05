test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("phyloseqize creates a phyloseq object", {
  bristle_data <- bristler::bristle_sample
  bristle_data$ssr <- 1234
  mapfile <- dplyr::tibble(ssr=1234,label="baseline")
  p <- phyloseqize(bristle_data, mapfile)
  expect_s4_class(p, "phyloseq")

})
