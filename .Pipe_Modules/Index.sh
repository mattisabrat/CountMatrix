#!/usr/bin/env bash

echo "Indexing Script Called"

 
while getopts ':i:o:n:g:f:l:' flag; do
    case ${flag} in
        i) UnIndexed_FA=${OPTARG} ;;
        o) Index_Destination=${OPTARG} ;;
	    n) nThreads=${OPTARG} ;;
	    g) Annotation=${OPTARG} ;;
	    f) Index_Flags="${OPTARG}" ;; 
	    l) LogOut_Destination=${OPTARG} ;;
        *) echo "Unexpected option ${flag}" ;;
    esac
done

 
Base_String_a="STAR --runThreadN ${nThreads} --runMode genomeGenerate --genomeDir ${Index_Destination}"
Base_String_b="--genomeFastaFiles ${UnIndexed_FA} --sjdbGTFfile ${Annotation}"

eval "${Base_String_a} ${Base_String_b} ${Index_Flags}"
