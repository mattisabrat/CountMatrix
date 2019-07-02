#!/usr/bin/env bash

echo "Trim script called"

while getopts ':i:o:r:n:f:l:j:' flag; do
    case "${flag}" in
        i) Fastqs_Joined="${OPTARG}" ;;
        o) Trim_Output_File="${OPTARG}" ;;
        r) Read_Count="${OPTARG}" ;;
        n) nThreads="${OPTARG}" ;;
        l) Trim_Log="${OPTARG}" ;;
        f) Trim_Flags="${OPTARG}" ;;
        j) Jar="${OPTARG}" ;;
        *) echo "Unexpected option ${flag}" ;;
    esac
done

Base_String="java -jar ${Jar}"

case ${Read_Count} in
    1) Read_String="SE -threads ${nThreads} ${Fastqs_Joined} ${Trim_Output_File}" ;;
    2) Read_String="PE -threads ${nThreads} ${Fastqs_Joined} -baseout ${Trim_Output_File}" ;;
esac




eval "${Base_String} ${Read_String} ${Trim_Flags}"
