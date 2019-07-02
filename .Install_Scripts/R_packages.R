#!/usr/bin/env Rscript

Cran_packages<-c("getopt", "readr", "BiocManager")
Bioc_packages<-c("tximport", "Rsubread")

install.packages(Cran_packages, repos="https://cloud.r-project.org")

library("BiocManager")

BiocManager::install(Bioc_packages)
