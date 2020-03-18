#!/usr/bin/env Rscript
 
library("getopt")
library("plyr")

print("Concatenating")
 
#read in flags
spec <- matrix(c(
      'Agg_Vec_Paths',         'i', 1, "character",
      'FC_Summary_Path',       'f', 1, "character",
      'RDS_Destination',       'o', 1, "character",
      'CSV_Destination',       'c', 1, "character",
      'nThreads',              'n', 1, "integer"),
    byrow=TRUE, ncol=4)
    opt <- getopt(spec) 

#Break apart the list variables that had to be read in as a single string
Agg_File_Paths <- strsplit(x = opt$Agg_Vec_Paths,
                                 split = " SPLIT ",
                                 fixed = TRUE)[[1]]
                      
                                 
#inits
data       <-list()
counts     <-list()
stat       <-list()
    
#Pull data
for (r in 1:length(Agg_File_Paths)) {
    data[[r]]      <- readRDS(Agg_File_Paths[r]) 
    counts[[r]]    <- as.data.frame(data[[r]]$counts)
    counts[[r]]$rn <- rownames(counts[[r]]) #create rownames column for the join. 
    stat[[r]]      <- as.data.frame(data[[r]]$stat)
    annotation     <- as.data.frame(data[[r]]$annotation)
}
    

#Bind
all_counts <- join_all(counts)
all_stat   <- join_all(stat)
    
#Rownames
rownames(all_counts) <- all_counts$rn
all_counts$rn <- NULL
Count_Matrix <- list(all_counts, all_stat, annotation)
names(Count_Matrix) <- c('counts', 'stat', 'annotation')

#Also have to output the FC report
write.table(Count_Matrix$stat, file= opt$FC_Summary_Path,
            quote=FALSE, row.names=FALSE, sep="\t")
               

#Write the reports
saveRDS(Count_Matrix, file = opt$RDS_Destination)
write.csv2(x = Count_Matrix$counts,
          file = opt$CSV_Destination,
          row.names = TRUE)
