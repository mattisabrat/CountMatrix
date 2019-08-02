#!/usr/bin/env Rscript

library("getopt")

#Read in flags
    spec <- matrix(c(
      'Quant_File_Paths',      'i', 1, "character",
      'Aggregate_Destination', 'o', 1, "character",
      'Mode',                  'm', 1, "character",
      'nThreads',              'n', 1, "integer",
      'Annotation',            'g', 1, "character",
      'RData_Output',          'd', 1, "character",
      'Read_Count',            'r', 1, "integer",
      'Sample_Names',          's', 1, "character",
      'Flag_String',           'f', 1, "character",
      'Tx2Gene_Path',          't', 1, "character",
      'FC_Destination',        'c', 1, "character"),
    byrow=TRUE, ncol=4)
    opt <- getopt(spec)
    
#Break apart the list variables that had to be read in as a single string
    Quant_File_Paths <- strsplit(x     = opt$Quant_File_Paths,
                                 split = " SPLIT ",
                                 fixed = TRUE)[[1]]
    
    Sample_Names <- strsplit(x     = opt$Sample_Names,
                             split = " SPLIT ",
                             fixed = TRUE)[[1]]
    

#Determine if STAR or salmon work flow
    if ( opt$Mode == "STAR" ) {
        library("Rsubread")
        
print('  STARTED  ')
print(length(Sample_Names))
      
    #Use Read_Count to create an Is_Paired  boolean
        if ( opt$Read_Count == 1 ) {
          Is_Paired <- FALSE
        } else if ( opt$Read_Count == 2 ) {
          Is_Paired <- TRUE
        }
        
        #Build the strig used to invoke featureCounts
            Base_String <- paste("featureCounts( files = Quant_File_Paths,",
                                 "annot.ext = opt$Annotation, isGTFAnnotationFile = TRUE,",
                                 "nthreads  = opt$nThreads, isPairedEnd = Is_Paired,",
                                 sep=" ")
            Full_String <- paste( Base_String, opt$Flag_String, ")" , sep=" " )
            Full_String <- gsub("[\r\n]", "", Full_String)
        
        #Execute the featureCounts string
            Aggregate_Counts <- eval( parse( text = Full_String ))
            print(length(colnames(Aggregate_Counts$counts)))
            print(length(colnames(Aggregate_Counts$stat)))
            colnames(Aggregate_Counts$counts) <- Sample_Names #Replace paths with sample names
            
        #Reformat and sepparate the stats table for multiqc    
            colnames(Aggregate_Counts$stat) <- c("Status", Sample_Names) 
            
        #Output the stats table for multiqc to find
            write.table(Aggregate_Counts$stat, file= opt$FC_Destination,
                        quote=FALSE, row.names=FALSE, sep="\t")
            
        #Output both the count matrix (.csv) and the entire featureCounts results (.RData)
            saveRDS(Aggregate_Counts, file = opt$RData_Output)
            write.csv2(x = Aggregate_Counts$counts,
                       file = opt$Aggregate_Destination,
                       row.names = TRUE)
      
      
    } else if (opt$Mode == "salmon"){
        library("tximport")
        library("readr")
        
        #Add the sample names as the column names of the path containing vector
            names(Quant_File_Paths) <- Sample_Names

        #Readin the Tx2Gene Matrix
            tx2gene <- read.csv2(file = opt$Tx2Gene_Path, header = TRUE)
        
        #Build the string to invoke tximport
            Base_String <- 'tximport(files = Quant_File_Paths, type = "salmon", tx2gene = tx2gene,'
            Full_String <- paste( Base_String, opt$Flag_String, ")" , sep=" " )
            Full_String <- gsub("[\r\n]", "", Full_String)
            
        #Run tximport
            Aggregate_Counts <- eval( parse( text = Full_String ))
        
        #Output the count matrix as (.csv) and (.RData)
            saveRDS(Aggregate_Counts, file = opt$RData_Output)
            write.csv2(x = Aggregate_Counts,
                       file = opt$Aggregate_Destination,
                       row.names = TRUE)
        
    }
