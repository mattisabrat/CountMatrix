#!/usr/bin/env Rscript
 
library("getopt")
library("plyr")

print("Concatenating")
 
#read in flags
spec <- matrix(c(
      'Agg_Vec_Paths',         'i', 1, "character",
      'RDS_Destination',       'o', 1, "character",
      'CSV_Destination',       'c', 1, "character",
      'Mode',                  'm', 1, "character",
      'nThreads',              'n', 1, "integer"),
    byrow=TRUE, ncol=4)
    opt <- getopt(spec) 

#Break apart the list variables that had to be read in as a single string
RDS_File_Paths <- strsplit(x = opt$Agg_Vec_Paths,
                                 split = " SPLIT ",
                                 fixed = TRUE)[[1]]

#if star
if (opt$Mode == 'STAR'){
    data       <-list()
    counts     <-list()
    stat       <-list()
    
    for (r in 1:length(RDS_File_Paths)) {
        data[[r]]      <- readRDS(RDS_File_Paths[r])
        counts[[r]]    <- data[[r]]$counts
        stat[[r]]      <- data[[r]]$stat
        annotation     <- data[[r]]$annotation  
    }

    all_counts <- join_all(counts, by=row.names)
    all_stat   <- join_all(stat,   by=row.names)

    Count_Matrix <- list(all_counts, all_stat, annotation)
    names(Count_Matrix) <- c('counts', 'stat', 'annotation')
                               

} else if (opt$Mode == 'salmon') {
    data       <-list()
    counts     <-list()
    abundance  <-list()
    
    for (r in 1:length(RDS_File_Paths)) {
        data[[r]]      <- as.data.frame(readRDS(RDS_File_Paths[r]))
        counts[[r]]    <- data[[r]]$counts
        length         <- data[[r]]$length
        abundance[[r]] <- data[[r]]$abundance      
    }
    
    all_counts      <- join_all(counts,    by=row.names)
    all_abundance   <- join_all(abundance, by=row.names)
    
    Count_Matrix <- as.data.frame(counts     <- all_counts,
                                  abundance  <- all_abundance,
                                  length     <- length)
}

saveRDS(Count_Matrix, file = opt$RDS_Destination)
write.csv2(x = Count_Matrix$counts,
          file = opt$CSV_Destination,
          row.names = TRUE)
