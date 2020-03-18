#!/usr/bin/env bash


#--------------------------------------------------------------------------
#Set up the Path so that all aspects of the pipeline are invocable
	#Setting the path within the pipeline instead of within the environment
	#adds portability and prevents user error
#--------------------------------------------------------------------------

PATH=$(getconf PATH)
java_dir="$(which java)"
java_dir=${java_dir%java}
export PATH="$java_dir":$PATH
export PATH=$PWD/.bds:$PATH
export PATH=$PWD/.Salmon/bin:$PATH
export PATH=$PWD/.STAR/source:$PATH
export PATH=$PWD/.FastQC:$PATH
export PATH=$PWD/.R/bin:$PATH
export PATH=$PWD/.Python/bin:$PATH
export PYTHONPATH=$PWD/.Python/bin

#-------------------------------------------------------------------------
#Read in the Experimental Directory supplied on the mandatory -e flag
#-------------------------------------------------------------------------

Provided_Dir=false
Provided_Mode=false
Provided_Flags=false
Trim=false
nThreads=1

while getopts ':e:n:ft' flag; do
  case "${flag}" in
    e) Provided_Dir=true; Experiment="${OPTARG}";;  #mandatory flag
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

#--------------------------------------------------------------------------
#Execute the pipeline on the specified directory
#--------------------------------------------------------------------------

bds -c $PWD/.bds/bds.config ./.CountMatrix.bds -e ${Experiment} -n ${nThreads} -f ${Provided_Flags} -t ${Trim}
