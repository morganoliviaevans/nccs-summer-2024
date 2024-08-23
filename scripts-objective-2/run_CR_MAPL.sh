#!/bin/bash
##########################################
# Last update: 10 Aug. 2023 by Lucas Snyder
# PLEASE REMEMBER TO PIPE THIS SCRIPT'S OUTPUT TO "tee" SO IT CAN BE SAVED!
# This is a script to run MAPL using ExtDataDriver.x in Checkpoint_Restart mode.
# This script expects to be located in a directory that contains supporting config files like CAP1, CAP2, CAP, AGCM1, AGCM2, etc.
# This script assumes that you have NX and NY pairs (which MUST be tab separated!) saved in a file, which you pass as the only argument.
# This script assumes that the grid size has been manually set, and any splitting or setting of aggregator threads is already set as well. This script will simply iterate through NX,NY pairs.
##########################################

# Check if the input file is provided as an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

# Input file provided as the first argument
input_file=$1

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Error: File '$input_file' not found."
  exit 1
fi

echo "Loading Intel Compilers and IMPI"
module purge
module load comp/intel/2021.6.0
module load mpi/impi/2021.6.0
source /gpfsm/dnb09/bench/geosio/scu-17/MAPL/install/bin/g5_modules.sh
module list
echo

# In case of emergency, break glass
trap "echo; exit" INT

# For each line in the input file, assign nx and ny based on tab separator
while IFS=$'\t' read -r nx ny; do
  if [ -n "$nx" ] && [ -n "$ny" ]; then  # Check if the line contains two columns
    echo "Read NX and NY values: nx = $nx, ny = $ny"  # Sanity check that it read them correctly
    echo

    let "num_procs=$nx * $ny"  # Calculate the number of MPI processes needed
    echo "Calculated number of processes: $num_procs"

    #ls -lah
    # Remove any old nc4 and rcx files so that write test can occur
    echo "Removing old files..."
    rm root_im*
    #ls -lah

    echo

    # Modify AGCM1.rc to new NX and NY
    echo "Changing NX to $nx and NY to $ny in AGCM1.rc"
    sed -i 's/^NX: .*/NX: '$nx'/' AGCM1.rc
    sed -i 's/^NY: .*/NY: '$ny'/' AGCM1.rc
    head -n 2 AGCM1.rc

    echo

    # Modify AGCM2.rc to new NX and NY
    echo "Changing NX to $nx and NY to $ny in AGCM2.rc"
    sed -i 's/^NX: .*/NX: '$nx'/' AGCM2.rc
    sed -i 's/^NY: .*/NY: '$ny'/' AGCM2.rc
    head -n 2 AGCM2.rc

    echo

    # Set CAP.rc to perform write test
    echo "Resetting CAP.rc to run CAP1 (writes)."
    sed -i '2s/.*/CAP1.rc/' CAP.rc
    sed -i '3s/.*/#CAP2.rc/' CAP.rc
    cat CAP.rc

    # Run the write test, direct /dev/null to stdin because read is weird
    echo "Running ExtDataDriver.x with $num_procs procs for write test."
    mpirun -np $num_procs ExtDataDriver.x < /dev/null

    echo

    # Set CAP.rc for read test
    echo "Switching CAP.rc to run CAP2 (read)."
    sed -i '2s/.*/#CAP1.rc/' CAP.rc
    sed -i '3s/.*/CAP2.rc/' CAP.rc
    cat CAP.rc

    # Run the read test, direct /dev/null to stdin because read is weird
    echo "Running ExtDataDriver.x with $num_procs procs for read test."
    mpirun -np $num_procs ExtDataDriver.x < /dev/null

    echo

    echo "Finished with NX = $nx and NY = $ny"

    sleep 4
  fi
done < "$input_file"

echo

echo "Done!"