#!/usr/bin/env bash

echo "QC script called"

while getopts ':i:o:r:' flag; do
    case "${flag}" in
        i) Fastqs_Joined="${OPTARG}" ;;
        o) FastQC_Destination="${OPTARG}" ;;
        *) echo "Unexpected option ${flag}" ;;
    esac
done

eval "fastqc ${Fastqs_Joined} --outdir ${FastQC_Destination}"
