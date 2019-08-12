#!/usr/bin/env bash


#--------------------------------------------------------------------------
#Set up the Path so that all aspects of the pipeline are invocable
	#Setting the path within the pipeline instead of within the environment
	#adds portability and prevents user error
#--------------------------------------------------------------------------

PATH=$(getconf PATH)
java_dir="$(which java)"
java_dir=${java_dir%java}
export PATH=:"$java_dir"
export PATH=$PATH:$PWD/.bds
export PATH=$PATH:$PWD/.Salmon/bin
export PATH=$PATH:$PWD/.STAR/source
export PATH=$PATH:$PWD/.FastQC
export PATH=$PATH:$PWD/.R/bin
export PATH=$PATH:$PWD/.Python/bin
export PYTHONPATH=$PWD/.Python/bin

#-------------------------------------------------------------------------
#Read in the Experimental Directory supplied on the mandatory -e flag
#Determine if the pipeline is being run in STAR of salmon mode 
	#using mandatory -m flag 
#-------------------------------------------------------------------------

Provided_Dir=false
Provided_Mode=false
Provided_Flags=false
Trim=false
nThreads=1

while getopts ':e:m:n:ft' flag; do
  case "${flag}" in
    e) Provided_Dir=true; Experiment="${OPTARG}";;  #mandatory flag
    m) Provided_Mode=true; Mode="${OPTARG}";;       #mandatory flag
    f) Provided_Flags=true ;;
    t) Trim=true ;;
    n) nThreads="${OPTARG}" ;;
  esac
done
OPTIND=1 #manualy reset getopts for potential later use


#-------------------------------------------------------------------------------------
#Catch any incorrect inputs and throw errors at the foolish users.
#-------------------------------------------------------------------------------------

#Handle incorrect -e usage
if [ "${Provided_Dir}" = false ]; then 
	echo "ERROR: Pipeline requires -e Experimental Directory"
	exit 1
elif [ ! -d "${Experiment}" ]; then
    echo "ERROR: Provided Experimental Directory doesn't exist"
    exit 2
else
	echo "Running ${Experiment}"
fi 

#Handle incorrect -m usage
if [ "${Provided_Mode}" = false ]; then
    echo "ERROR: Pipeline requires -m {salmon, STAR}"
    exit 3
elif [ ! "${Mode}" = "salmon" ] && [ ! "${Mode}" = "STAR" ]; then
    echo "ERROR: Invalid -m input. Options are {salmon, STAR}"
    exit 4  
else
    echo "Pipeline in ${Mode} mode" 
fi


#--------------------------------------------------------------------------
#Execute the pipeline on the specified directory
#--------------------------------------------------------------------------

bds -c $PWD/.bds/bds.config ./.CountMatrix.bds -e ${Experiment} -m ${Mode} -n ${nThreads} -f ${Provided_Flags} -t ${Trim}

#A test file used for debugging
#./Test.bds -e ${Experiment} -m ${Mode}
