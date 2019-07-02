#!/usr/bin/env bash

echo "Alignment script called"

while getopts ':o:m:n:1:2:r:i:f:' flag; do
    case "${flag}" in
        r) Read_Count=${OPTARG} ;;
        i) Index_Path=${OPTARG} ;;
        1) Read_1=${OPTARG} ;;
        2) Read_2=${OPTARG} ;;
        o) Quant_Destination=${OPTARG} ;;
	    m) Mode=${OPTARG} ;;
	    n) nThreads=${OPTARG} ;; 
	    f) Quant_Flags="${OPTARG}" ;;
        *) echo "Unexpected option ${flag}" ;;
    esac
done

#Now lets build the string of the designated command in pieces
case ${Mode} in
    salmon) Base_String="salmon quant -p ${nThreads} -i ${Index_Path} -o ${Quant_Destination} -l A"
        case ${Read_Count} in
            1) Read_String="-r ${Read_1}" ;;
            2) Read_String="-1 ${Read_1} -2 ${Read_2} --discardOrphansQuasi" ;;
        esac ;;
    STAR) Base_String="STAR --genomeDir ${Index_Path} --outFileNamePrefix ${Quant_Destination} --runThreadN ${nThreads} --outSAMtype BAM SortedByCoordinate" 
        case ${Read_Count} in
            1) Read_String="--readFilesIn ${Read_1} --readFilesCommand gunzip -c" ;;
            2) Read_String="--readFilesIn ${Read_1} ${Read_2} --readFilesCommand gunzip -c" ;;
        esac ;;
esac

eval "${Base_String} ${Read_String} ${Quant_Flags}"
