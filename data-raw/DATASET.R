## code to prepare `DATASET` dataset goes here


bristle_sample <- read_bristle_table(filepath=system.file("extdata", package = "bristler", "BristleHealthRaw.xlsx"))
usethis::use_data(bristle_sample, overwrite = TRUE)
