#!/usr/bin/env bash


input_path=$1

source bash_functions.sh

shopt -s nullglob
reads=( $input_path/*.fastq.gz )
shopt -u nullglob

msg "INFO: ${#reads[@]} FastQ files found"

if [[ $((${#reads[@]} % 2)) -ne 0 ]]; then
  msg "ERROR: uneven number (${#reads[@]}) of FastQ files" >&2
  exit 1
fi
if [[ ${#reads[@]} -eq 0 ]]; then
  msg "ERROR: unable to find FastQ files in ${input_path}" >&2
  exit 1
fi

touch "find_infiles.success.txt"