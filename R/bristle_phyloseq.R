

#' @title Make a Phyloseq Object from a Bristle Dataframe
#' @description You'll need to pass both a canonical Bristle dataframe
#' and a mapfile (see instructions)
#' @export
#' @param bristle_df dataframe in canonical Bristle format
#' @param mapfile dataframe (see instructions)
#' @return phyloseq object
phyloseqize <- function(bristle_df, mapfile) {
  bristle_experiment <- bristle_df %>%
    transmute(ssr,
              tax_name = genus,
              count = abundance * 10000,
              tax_rank = "genus")
  e <-
    bristle_experiment %>%
    dplyr::select(tax_name, 1, count) %>%
    tidyr::pivot_wider(names_from = ssr,
                values_from = count,
                values_fn = {
                  sum
                })
  ssrs <- unique(bristle_experiment$ssr)
  e.map <- mapfile[match(ssrs, mapfile$ssr), ]
  #row.names(e.map)<-e.map$ssr
  qiime_tax_names <- sapply(e[1], function (x)
    paste("g__", x, sep = ""))
  e.taxtable <-
    phyloseq::build_tax_table(lapply(qiime_tax_names, phyloseq::parse_taxonomy_qiime))
  dimnames(e.taxtable)[[1]] <- qiime_tax_names
  e.matrix <- as.matrix(e[, 2:ncol(e)])
  colnames(e.matrix) <- ssrs
  rownames(e.matrix) <- qiime_tax_names

  map.data.ps <- phyloseq::sample_data(mapfile)
  phyloseq::sample_names(map.data.ps) <- mapfile$ssr

  e.ps <- phyloseq::phyloseq(phyloseq::otu_table(e.matrix, taxa_are_rows = TRUE),
                   map.data.ps, #sample_data(e.map)) #,
                   phyloseq::tax_table(e.taxtable))

  return(e.ps)

}
