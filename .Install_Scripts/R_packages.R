#!/usr/bin/env Rscript

#Handle everything with cran
repo <- "https://cloud.r-project.org"

lib <- paste(getwd(),"/.R/lib/R/library",sep="")

install.packages("plyr", lib = lib, repos = repo)
install.packages("BiocManager", lib = lib, repos = repo) 
install.packages("getopt",lib = lib, repos = repo)
install.packages("readr", lib = lib, repos = repo) 


#Handle everything in bioconductor
library("BiocManager")
BiocManager::install("Rsubread")
