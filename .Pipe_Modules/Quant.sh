#!/usr/bin/env bash

echo "Alignment script called"

while getopts ':o:n:1:2:r:i:f:' flag; do
    case "${flag}" in
        r) Read_Count=${OPTARG} ;;
        i) Index_Path=${OPTARG} ;;
        1) Read_1=${OPTARG} ;;
        2) Read_2=${OPTARG} ;;
        o) Quant_Destination=${OPTARG} ;;
	    n) nThreads=${OPTARG} ;; 
	    f) Quant_Flags="${OPTARG}" ;;
        *) echo "Unexpected option ${flag}" ;;
    esac
done

#Now lets build the string of the designated command in pieces
Base_String="STAR --genomeDir ${Index_Path} --outFileNamePrefix ${Quant_Destination} --runThreadN ${nThreads}  --outSAMtype BAM SortedByCoordinate" 
    case ${Read_Count} in
        1) Read_String="--readFilesIn ${Read_1} --readFilesCommand gunzip -c" ;;
        2) Read_String="--readFilesIn ${Read_1} ${Read_2} --readFilesCommand gunzip -c" ;;
    esac

eval "${Base_String} ${Read_String} ${Quant_Flags}"
