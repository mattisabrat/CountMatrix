 #!/usr/bin/env bash
 
 echo "MultiQC Script Called"
 
 while getopts ':e:' flag; do
    case ${flag} in
        e) Experiment=${OPTARG} ;;
        *) echo "Unexpected option ${flag}" ;;
    esac
done
    

#Create the report
    multiqc ${Experiment} -f -o ${Experiment} -n Quality_Control --interactive
