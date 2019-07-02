#!/usr/bin/env bash

echo "Indexing Script Called"

 
while getopts ':i:o:m:n:g:f:' flag; do
    case ${flag} in
        i) UnIndexed_FA=${OPTARG} ;;
        o) Index_Destination=${OPTARG} ;;
	    m) Mode=${OPTARG} ;;
	    n) nThreads=${OPTARG} ;;
	    g) Annotation=${OPTARG} ;;
	    f) Index_Flags="${OPTARG}" ;; 
	    l) LogOut_Destination=${OPTARG} ;;
        *) echo "Unexpected option ${flag}" ;;
    esac
done

case ${Mode} in
    STAR) 
        Base_String_a="STAR --runThreadN ${nThreads} --runMode genomeGenerate --genomeDir ${Index_Destination}"
        Base_String_b="--genomeFastaFiles ${UnIndexed_FA} --sjdbGTFfile ${Annotation}"
    ;; 
    salmon)
        Base_String_a="salmon index -p ${nThreads} -t ${UnIndexed_FA} -i ${Index_Destination}"
        Base_String_b="" 
    ;;
esac

eval "${Base_String_a} ${Base_String_b} ${Index_Flags}"


##Move the Log.out file from STAR
case ${Mode} in
    STAR) 
        mv $PWD/Log.out ${LogOut_Destination}
    ;; 
esac
