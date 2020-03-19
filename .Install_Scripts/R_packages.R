#!/usr/bin/env Rscript

#Handle everything with cran
install.packages("devtools", repos = "https://cloud.r-project.org")
install.packages("plyr", repos = "https://cloud.r-project.org")
library("devtools")

install_version("getopt",      version = "1.20.3", repos = "https://cloud.r-project.org")
install_version("readr",       version = "1.3.1",  repos = "https://cloud.r-project.org") 
install.packages("BiocManager", repos = "https://cloud.r-project.org") 


#Handle everything in bioconductor
library("BiocManager")
BiocManager::install("Rsubread")
