

## for testing, generate a new .rds file like this:
# clip_data <- clipr::read_clip_tbl()  # copy/paste a section from https://app.bristlehealth.com/samples/raw
# saveRDS(clip_data,"tests/testthat/clipdata.rds", version = 2)
# # read it like this:
# readRDS("tests/testthat/clipdata.rds")

b <- bristler::bristle_sample

test_that("genus from species", {
  expect_equal(genus_from_species("test microbe"), "test")
  expect_equal(genus_from_species("microbe"), "microbe")
})

test_that("plot_freq works", {
  p <- bristler::plot_bristle_freq(head(b))
  expect_equal(p$data$sum[1], 0.2629591, tolerance = 0.001 )
})

test_that("treemap works", {
  t <- bristler::treemap_of_sample(b)
  expect_equal(as.character(t[5,1]), "Bacillus")
})

test_that("stright copy works",{
  c <- readRDS("clipdata.rds")
  clipr::write_clip(c, allow_non_interactive = TRUE)
  tc <- clip_bristle_table()
  expect_equal(as.character(tc[2,1]), "Bacillus")
  expect_equal(as.numeric(tc[2,3]), 0.00909945813, tolerance = 0.0001)
})

file.remove("Rplots.pdf") # clean up after the tests

# test_that("copy bristle works", {
#   load("clipdata.rda")
#   clipr::write_clip(clip_data)
#   tc <- clip_bristle_table()
#   expect_equal(as.character(tc[5,1]), "Rothia")
# })
#

