#!/bin/bash

#export CC_MODULE="comp/intel/2021.4.0"
#export MPI_MODULE="mpi/impi/2021.4.0"

#export CC_MODULE="comp/intel/2021.4.0"
#export MPI_MODULE="mpi/impi/2021.11"

#export CC_MODULE="comp/intel/2021.4.0"
#export MPI_MODULE="mpi/impi/2021.13"

export CC_MODULE="comp/gcc/12.3.0"
export MPI_MODULE="mpi/impi/2021.13"

#export CC_MODULE="comp/gcc/13.2.0"
#export MPI_MODULE="mpi/openmpi/4.1.5-gcc"

#export CC_MODULE="comp/gcc/13.2.0"
#export MPI_MODULE="mpi/openmpi/5.0.3-gcc"
#export MPI_MODULE_OPTS="--mca prte_silence_shared_fs 1"

export CC_VERSION="$(echo ${CC_MODULE} | sed 's:/:_:g')"
export MPI_VERSION="$(echo ${MPI_MODULE} | sed 's:/:_:g')"

export MESSAGESIZE="8192:8192"
export ITERATIONS="1"
export MEMORYLIMIT="4294967296"

export BASEDIR="$NOBACKUP/objective-2/benchmarks/gmao/milan"

export RESULTSDIR="${BASEDIR}/results/${CC_VERSION}-${MPI_VERSION}"

if [ ! -d "${BASEDIR}/${RESULTSDIR}" ]; then
  mkdir -m 0700 ${RESULTSDIR}
fi

echo "benchmark,compiler,MPI,tuning,nodes,tasks_per_node,total_tasks,messagesize,average_latency,minimum_latency,maximum_latency,iterations,time_elapsed" >> ${RESULTSDIR}/results-${MPI_VERSION}.csv

for NODESTASKS in 50:2 50:4 50:8 50:16 50:32 50:46 50:64 50:126 64:126
#for NODESTASKS in 2:2
do
  read -r NONODES TASKS <<< $(echo ${NODESTASKS} | awk -F: '{print $1,$2}')
  sleep 2
  sbatch --export=ALL --no-requeue --constraint=mil --partition=compute --qos=admin --reservation=OSUbench --time=02:00:00 \
    --chdir=${BASEDIR} \
    --output=output/%j-%x.out \
    --dependency=singleton --switches=1 \
    --job-name=osu_benchmarks \
    --nodes=${NONODES} \
    --ntasks-per-node=${TASKS} \
    osu_benchmarks.slurm
done