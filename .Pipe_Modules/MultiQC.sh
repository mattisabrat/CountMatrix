 #!/usr/bin/env bash
 
 echo "MultiQC Script Called"
 
 while getopts ':e:f:' flag; do
    case ${flag} in
        e) Experiment=${OPTARG} ;;
        f) MultiQC_Flags="${OPTARG}" ;;
        *) echo "Unexpected option ${flag}" ;;
    esac
done
    
#Build the string
Base_String="multiqc ${Experiment} -f -o ${Experiment} -n Quality_Control"

#Create the report
eval "${Base_String} ${MultiQC_Flags}"
