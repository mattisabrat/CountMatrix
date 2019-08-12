#!/usr/bin/env Rscript

#Handle everything with cran
install.packages("devtools")
library("devtools")

install_version("getopt",      version = "1.20.3", repos = "https://cloud.r-project.org")
install_version("readr",       version = "1.3.1",  repos = "https://cloud.r-project.org") 
install_version("BiocManager", version = "1.30.4", repos = "https://cloud.r-project.org") 


#Handle everything in bioconductor
library("BiocManager")
Bioc_packages<-c("tximport", "Rsubread")
BiocManager::install(Bioc_packages, version = '3.9')
