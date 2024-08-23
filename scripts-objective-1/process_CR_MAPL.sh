#!/bin/bash
##########################################
# Last update: 8 Aug. 2023 by Lucas Snyder
# This is a script to pull the relevant IO timings from the output of MAPL Checkpoint_Restart runs.
# The times will be sent to STDOUT and saved in two files: one for reads and one for writes.
# This script assumes that you have the Checkpoint_Restart run results saved in a file, which you pass as the only argument.
# This script does NOT (currently) support the granular timing output as seen with Hist_ExtData output.
##########################################

if [ $# -ne 1 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

IN=$1

# Check if the input file exists
if [ ! -f "$IN" ]; then
  echo "Error: File '$IN' not found."
  exit 1
fi

# In case of emergency, break glass
trap "echo; exit" INT

arrIN=(${IN//_/ })
echo ${arrIN[0]}

echo "Retrieving write times..."
sed -rn '/profiler: --Root/p' $1 | tr -s ' ' | cut -d ' ' -f 5 | awk 'NR%2' | tee ${arrIN[0]}_writes.txt

echo

echo "Retrieving read times..."
sed -rn '/profiler: --Root/p' $1 | tr -s ' ' | cut -d ' ' -f 5 | awk 'NR%2==0' | tee ${arrIN[0]}_reads.txt