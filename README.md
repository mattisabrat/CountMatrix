# JarvRNAPipe2
Fully Automated RNAseq pipeline, goes from raw reads to count matrix. Includes quality  control.

## What does it do?

This pipeline automates and parellizes Illumina NGS processing to produce a count matrix ready for differential expression analysis analyses. It also automates all quality control for this process. Reads can be Paired or Single End. It builds indexes and performs allignment using [STAR](https://github.com/alexdobin/STAR) or [Salmon](https://github.com/COMBINE-lab/salmon) as specified by the user, the rest of the pipeline adjusts its workflow accordingly. Trimming is optionally performed by [Trimmomatic](https://github.com/timflutre/trimmomatic) if specified. Read quality control is performed by [FastQC](https://github.com/s-andrews/FastQC). Aligned reads are aggregated to genes using [FeatureCounts](https://bioconductor.org/packages/release/bioc/html/Rsubread.html) for [STAR](https://github.com/alexdobin/STAR) and [Tximport](https://bioconductor.org/packages/release/bioc/html/tximport.html) for [Salmon](https://github.com/COMBINE-lab/salmon). Quality control reports are generated using [MultiQC](https://github.com/ewels/MultiQC).

The pipeline itself is uses [BigDataScript (BDS)](http://pcingola.github.io/BigDataScript/) or organize the execution of bash, and [R](https://www.r-project.org/) scripts for each required task. [BDS](http://pcingola.github.io/BigDataScript/) allows this pipeline to be deployed on personal machines, or clusters with minimal modifcation, see the [BDS docs](http://pcingola.github.io/BigDataScript/manual/site/index.html). [BDS](http://pcingola.github.io/BigDataScript/) handles task parellelization and queueing, including interfacing with cluster task managers. 


## Credit where credit is due

This pipeline is an automated wrapper for incredible pre-exisiting softwares. Please check out the work involved in everything under the hood.
* [BigDataScript](http://pcingola.github.io/BigDataScript/)
* [STAR](https://github.com/alexdobin/STAR)
* [Salmon](https://github.com/COMBINE-lab/salmon)
* [Trimmomatic](https://github.com/timflutre/trimmomatic)
* [FeatureCounts](https://bioconductor.org/packages/release/bioc/html/Rsubread.html)
* [Tximport](https://bioconductor.org/packages/release/bioc/html/tximport.html)
* [FastQC](https://github.com/s-andrews/FastQC)
* [MultiQC](https://github.com/ewels/MultiQC)

## Prerequisites
* Java 1.8 - Required by [BigDataScript](http://pcingola.github.io/BigDataScript/)

## Installation
Bad news:  The only way to install is through git and I've only tried it so far on Linux systems. 

Good news: It self assembles. 

    git clone https://github.com/mattisabrat/JarvRNAPipe2

    cd JarvRNAPipe2/

    ./Install.sh

## Usage

    ./Jarvis_RNAseq.sh -e ${Experimental_Directory} -m ${Mode}

Where {Experimental_Directory} is the name of a **correctly formatted directory** and {Mode} is either **STAR** or **salmon**

### Options

## Experimental Directory Structure

## Required files and formats
### STAR

### Salmon

## Versions
