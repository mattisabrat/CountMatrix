# JarvRNAPipe2
Fully Automated RNAseq pipeline, goes from raw reads to count matrix. Includes quality  control.

## What does it do?

This pipeline automates and parellizes Illumina NGS processing to produce a count matrix ready for differential expression analysis analyses. It also automates all quality control for this process. Reads can be Paired or Single End. It builds indexes and performs allignment using [STAR](https://github.com/alexdobin/STAR) or [Salmon](https://github.com/COMBINE-lab/salmon) as specified by the user, the rest of the pipeline adjusts its workflow accordingly. Trimming is optionally performed by [Trimmomatic](https://github.com/timflutre/trimmomatic) if specified. Read quality control is performed by [FastQC](https://github.com/s-andrews/FastQC). Aligned reads are aggregated to genes using [FeatureCounts](https://bioconductor.org/packages/release/bioc/html/Rsubread.html) for [STAR](https://github.com/alexdobin/STAR) and [Tximport](https://bioconductor.org/packages/release/bioc/html/tximport.html) for [Salmon](https://github.com/COMBINE-lab/salmon). Quality control reports are generated using [MultiQC](https://github.com/ewels/MultiQC).

The pipeline itself is uses [BigDataScript (BDS)](http://pcingola.github.io/BigDataScript/) or organize the execution of bash, and [R](https://www.r-project.org/) scripts for each required task. [BDS](http://pcingola.github.io/BigDataScript/) allows this pipeline to be deployed on personal machines, or clusters with minimal modifcation, see the [BDS docs](http://pcingola.github.io/BigDataScript/manual/site/index.html). [BDS](http://pcingola.github.io/BigDataScript/) handles task parellelization and queueing, including interfacing with cluster task managers. 


## Credit where credit is due

This pipeline is an automated wrapper for incredible pre-exisiting softwares. Please check out the work involved in everything under the hood:
* [BigDataScript](http://pcingola.github.io/BigDataScript/)
* [STAR](https://github.com/alexdobin/STAR)
* [Salmon](https://github.com/COMBINE-lab/salmon)
* [Trimmomatic](https://github.com/timflutre/trimmomatic)
* [FeatureCounts](https://bioconductor.org/packages/release/bioc/html/Rsubread.html)
* [Tximport](https://bioconductor.org/packages/release/bioc/html/tximport.html)
* [FastQC](https://github.com/s-andrews/FastQC)
* [MultiQC](https://github.com/ewels/MultiQC)

## Prerequisites
* Java - Required by [BigDataScript](http://pcingola.github.io/BigDataScript/)

## Installation
Bad news:  The only way to install is through git and I've only tried it so far on Linux systems. 

Good news: It self assembles. 

    git clone https://github.com/mattisabrat/JarvRNAPipe2

    cd JarvRNAPipe2/

    ./Install.sh

## Basic Usage

    ./Jarvis_RNAseq.sh -e ${Experimental_Directory} -m ${Mode}

* -e ${Experimental_Directory} : Full path to a correctly formatted experimental directory 
* -m ${Mode} : STAR or salmon

### Additional Options
* -n ${nThreads} : The number of threads to be used by each task within the pipeline, default is 1
* -t : Activates trimming
* -f : Pipeline passes user supplied flags

## Experimental Directory Formatting
Your Experimental_Directory must be correctly formatted and contain the requisite files for the pathway to run. Regardless of pipeline mode, the Experimental directory must contain a folder named **raw_reads** which contains a subfolder for each sample, lets call them sample_folders, with the sample name as the sample_folder name. Each of these sample_folders  must contain the .fastq.gz files for that sample. The actual filenames don't really matter since it assigns the sample name based on the sample_folder not the .fastq.gz, though its always best to be consistent when naming files. 

The pipeline requires the read files be in .fastq.gz format.

### Paired vs. Single End Reads
Don't worry about it. Place the read files into sample folders in raw_reads and the pipeline will infer if you've given it PE or SE reads based on the number of .fastq.gz files. It should even be able to run if an experiment contains a mix of PE and SE samples, though I don't know why you would ever do that. 

### STAR
In STAR mode, the Experimental_Directory must contain a folder named **genome**. This folder needs to contain an unindexed .fa genome file and a .gtf annotation file to build the genome indices.

### Salmon
In Salmon mode, the Experimental_Directory must contain a folder named **transcriptome**. This folder needs to contain a .fa trasnscriptome file and a .csv file for aggregating transcript level abundances to genes using tximport. For more info on constructing this .csv file, see the [tximport docs](https://bioconductor.org/packages/release/bioc/html/tximport.html).

### Reusing genome and trascriptome folders
Once the pipeline has been run, you can reuse the processed **transcriptome** or **genome** folder in subsequent experiments where the same genome/transcriptome is needed. Simply copy and pasted the whole folder into a new Experimental_Directory. When this new experiment is run through the pipeline, it will skip the indexing steps saving a bit of time. 

## Flags
This pipe uses overwritable defaults to manage the options used by each of its consituent softwares. The idea behind this is that a lab could set up the pipeline with their preferred settings. If these default settings are ever inappropriate for an experiment, they can be overwritten for a single pipeline run without having to touch the defaults, leaving the lab's typical pipeline settings unaltered.

The flags, whether default for user supplied, are appended to the base call for each task at the time of execution. For the **Aggregate** calls, which are in R, additional options are added before the closing parenthesis. The base calls can be found below. 

### Default Flags
Hidden in the head directory of the pipeline is a **.Default_Flags** folder containing a JarvRNAPipe_defaults.config file with the default flags for each task. Edit to set up your defaults, see their respective docs (linked above) for how each software uses flags. 

### Passing Flags
To overwrite the default flags for a pipeline run, the -f flag must be provided when invoking the pileline and the Experimental_Directory should contain a folder named **flags**. This folder should contain a **user_flags.config** file. Any flags provided in this file will overwrite the corresponding default flags. The pipeline will continue to use the defaults for all tasks not specified in user_flags.config.


### Base calls
* STAR indexing :

      STAR --runThreadN ${nThreads} --runMode genomeGenerate --genomeDir ${Index_Destination} --genomeFastaFiles ${UnIndexed_FA} --sjdbGTFfile ${Annotation}
* STAR quantifying PE :

      STAR --genomeDir ${Index_Path} --outFileNamePrefix ${Quant_Destination} --runThreadN ${nThreads} --readFilesIn ${Read_1} ${Read_2} --readFilesCommand gunzip -c
* STAR quantifying SE :

      STAR --genomeDir ${Index_Path} --outFileNamePrefix ${Quant_Destination} --runThreadN ${nThreads} --readFilesIn ${Read_1} --readFilesCommand gunzip -c
* STAR aggregating (featureCounts) :

      featureCounts( files = Quant_File_Paths, annot.ext = opt$Annotation, isGTFAnnotationFile = TRUE, nthreads = opt$nThreads, isPairedEnd = Is_Paired,)
* Salmon indexing :

      salmon index -p ${nThreads} -t ${UnIndexed_FA} -i ${Index_Destination}
* Salmon quantifying PE :

      salmon quant -p ${nThreads} -i ${Index_Path} -o ${Quant_Destination} -l A -1 ${Read_1} -2 ${Read_2}
* Salmon quantifying SE :

      salmon quant -p ${nThreads} -i ${Index_Path} -o ${Quant_Destination} -l A -r ${Read_1}
* Salmon aggreagting (tximport) :

      tximport( files = Quant_File_Paths, type = "salmon", tx2gene = tx2gene,)
* Trimmomatic PE :

      java -jar ${Jar} PE -threads ${nThreads} ${Fastqs_Joined} -baseout ${Trim_Output_File}
* Trimmomatic SE :

      java -jar ${Jar} SE -threads ${nThreads} ${Fastqs_Joined} ${Trim_Output_File}
      
* MultiQC

      multiqc ${Experiment} -f -o ${Experiment} -n Quality_Control
      
* FastQC

      fastqc ${Fastqs_Joined} --outdir ${FastQC_Destination}
      
## Software Versions
* R-3.6.0
* Python-3.5.5
* STAR-2.7.1a
* Salmon-0.9.1
* Trimmomatic-0.36
* tximport-1.12.3
* Rsubread-1.34.4

## Contributors
This pipeline was written and is maintained by [Matt Davenport](https://github.com/mattisabrat) (mdavenport@rockefeller.edu).
