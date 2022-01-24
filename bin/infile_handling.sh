#!/usr/bin/env bash


input_path=$1

source bash_functions.sh

shopt -s nullglob
reads=( $input_path/*.fastq.gz )
shopt -u nullglob

# Check that read files are valid pairs
for (( i=0; i<${#reads[@]}; i+=2 )); do
  read1=${reads[i]}
  read2=${reads[i+1]}
  b1=$(basename $read1 | cut -d _ -f 1 | sed 's/[-\.,]//g')
  b2=$(basename $read2 | cut -d _ -f 1 | sed 's/[-\.,]//g')
  if [ "$b1" != "$b2" ]; then
    msg "ERROR: improperly paired $b1 $b2" >&2
    exit 1
  fi
done

touch "infile_handling.success.txt"
