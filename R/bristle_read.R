# bristle_read.R


#' @title Read File Into Tidy Dataframe in Canonical Form
#' @return tidy data frame of Bristle data in canonical form
#' @export
#' @param filepath path to XLSX file
#' @return dataframe
read_bristle_table <- function(filepath=system.file("extdata", package = "bristler", "BristleHealthRaw.xlsx")) {

  raw_bristle_data_raw <- readxl::read_xlsx(filepath) %>% dplyr::filter(!is.na(Species))
  raw_bristle_data <- raw_bristle_data_raw %>%
    transmute(species = species_from_species(Species), genus = genus_from_species(Species),
              `relative abundance` = `Relative abundance`,
              percentile = `Percentile`)

  r <- raw_bristle_data %>%  transmute(.data$genus,.data$species,abundance=.data$`relative abundance`/100)



  return(r)

}

#' @title Genus from species
#' @description Return the genus of a species. Assumes it's the first word of the full species name.
#' @export
#' @param species_name char Species name
#' @return char Genus name (as a string)
genus_from_species <- function(species_name) {
  s <- stringr::str_split(species_name, pattern = " ")
  if(is.null(s)) return(NULL)
  if(is.list(s)) {
    s1 <- s
    s2 <- s1 %>% sapply(function(x){dplyr::first(dplyr::first(x))})
    return(s2)
  }
  return(s) # this is an "other" condition, if for whatever reason it's not a list

}

#' @title Species name from species
#' @description Return the species of a species. Assumes it's the second word of the full species name.
#' @export
#' @param species_name char Species name
#' @return char species name (as a string)
species_from_species <- function(species_name) {
  s <- stringr::str_split(species_name, pattern = " ")
  if(is.null(s)) return(NULL)
  if(is.list(s)) {
    s1 <- s
    s2 <- s1 %>% sapply(function(x){dplyr::first(dplyr::nth(x,2))})
    return(s2)
  }
  return(s) # this is an "other" condition, if for whatever reason it's not a list

}

#' @title Copy Clipboard into Tidy Dataframe in Canonical Form
#' @return tidy data frame of Bristle data in canonical form
#' @export
#' @return dataframe
clip_bristle_table <- function() {

  #clip_data <- clipr::read_clip_tbl()
  df <- as.data.frame(matrix(clipr::read_clip(allow_non_interactive = TRUE), ncol = 3, byrow = TRUE))
  names(df) <- c("genus","species","abundance")

  r <- dplyr::tibble(df[-1,]) %>%   # remove redundant first row
    transmute(genus,species,abundance = as.numeric(abundance)/100)



  return(r)

}


#' @title GGplot Frequency for Sample
#' @description Generate a ggplot of an ordered frequency of the genus in the sample
#' @param r_table Bristle canonical raw dataframe
#' @import ggplot2
#' @export
#' @return ggplot object
plot_bristle_freq <- function(r_table) {

  r_table %>%  dplyr::group_by(.data$genus) %>% dplyr::summarize(sum=sum(.data$abundance)) %>%
    dplyr::arrange(dplyr::desc(sum)) %>% dplyr::slice_max(order_by=sum, prop=.5) %>%
    ggplot(aes(x=reorder(.data$genus,-.data$sum), y=.data$sum)) +
    geom_col() +
    theme(axis.text.x=element_text(angle = 90, vjust = 0.5)) +
    labs(y="Abundance (%)", x = "Genus", title = "Bristle Health Result")
}


#' @title Merge Two Bristle Dataframes
#' @param table1 dataframe in Bristle canonical form
#' @param table2 dataframe in Bristle canonical form
#' @param label1 label for dataframe
#' @param label2 label for dataframe
#' @export
#' @return dataframe
combine_bristle_table <- function(table1, table2, label1, label2) {

  t1 <- table1 %>% cbind(label = label1)
  t2 <- table2 %>% cbind(label = label2)

  return(rbind(t1,t2))

}

#' @title Dataframe Version of Treemap
#' @description return a a dataframe version of this treemap
#' @param sample dataframe in Bristle Canonical Form
#' @export
#' @return dataframe
# inspired by https://yjunechoe.github.io/posts/2020-06-30-treemap-with-ggplot/
treemap_of_sample <- function(sample)
{
  tm <- sample %>%
    treemap::treemap(dtf=., index = c("genus"),
                     vSize="abundance",
                     vp = NULL,
                     draw=FALSE)
  tm_ <- tm[["tm"]] %>%
    # # calculate end coordinates with height and width
    dplyr::mutate(x1 = x0 + w,
           y1 = y0 + h) %>%
    # get center coordinates for labels
    dplyr::mutate(x = (x0+x1)/2,
           y = (y0+y1)/2) %>%
    dplyr::mutate(primary_group = 1.2)

  return(tm_)
}


