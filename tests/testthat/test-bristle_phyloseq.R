
bristle_data <- bristler::bristle_sample
bristle_data$ssr <- 1234
mapfile <- dplyr::tibble(ssr=1234,label="baseline")
p <- phyloseqize(bristle_data, mapfile)


test_that("phyloseqize creates a phyloseq object", {

  expect_s4_class(p, "phyloseq")

})


test_that("phyloseqize: dimensions are correct ", {

  expect_equal(as.numeric(nrow(phyloseq::otu_table(p))),38)
  expect_equal(as.character(phyloseq::tax_table(p)[5,1]), "Rothia")
  expect_equal(as.character(phyloseq::sample_data(p)[1,2]), "baseline")

})


