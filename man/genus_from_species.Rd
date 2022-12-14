% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bristle_read.R
\name{genus_from_species}
\alias{genus_from_species}
\title{Genus from species}
\usage{
genus_from_species(species_name)
}
\arguments{
\item{species_name}{char Species name}
}
\value{
char Genus name (as a string)
}
\description{
Return the genus of a species. Assumes it's the first word of the full species name.
}
