#!/usr/bin/env Rscript

library("getopt")
library("Rsubread")

#Read in flags
spec <- matrix(c(
    'Quant_Path',              'i', 1, "character",
    'Aggregate_Destination', 'o', 1, "character",
    'nThreads',              'n', 1, "integer",
    'Annotation',            'g', 1, "character",
    'RData_Output',          'd', 1, "character",
    'Read_Count',            'r', 1, "integer",
    'Sample_Names',          's', 1, "character",
    'Flag_String',           'f', 1, "character"),
byrow=TRUE, ncol=4)

opt <- getopt(spec)

#Break apart the list variables that had to be read in as a single string
Quant_File_Path <- c(opt$Quant_Path)  
Sample_Names    <- c(opt$Sample_Names)
    

#Use Read_Count to create an Is_Paired  boolean
if ( opt$Read_Count == 1 ) {
    Is_Paired <- FALSE
} else if ( opt$Read_Count == 2 ) {
    Is_Paired <- TRUE
}
        
#Build the strig used to invoke featureCounts
Base_String <- paste("featureCounts( files = opt$Quant_Path,",
                    "annot.ext = opt$Annotation, isGTFAnnotationFile = TRUE,",
                    "nthreads  = opt$nThreads, isPairedEnd = Is_Paired,",
                    sep=" ")
                    
Full_String <- paste( Base_String, opt$Flag_String, ")" , sep=" " )
Full_String <- gsub("[\r\n]", "", Full_String)
        
#Execute the featureCounts string
Aggregate_Counts <- eval( parse( text = Full_String ))
            
#Reformat and sepparate the stats table for multiqc
colnames(Aggregate_Counts$counts) <- Sample_Names #Replace paths with sample names    
colnames(Aggregate_Counts$stat)   <- c("Status", opt$Sample_Names) 
            
#Output the count vecotr (.rds) 
saveRDS(Aggregate_Counts, file = opt$RData_Output)
