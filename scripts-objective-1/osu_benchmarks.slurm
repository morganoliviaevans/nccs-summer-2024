#!/bin/bash

module load ${CC_MODULE} ${MPI_MODULE}

export MPI_TUNING="gmao+shm+ofi"
################################################################################
# Intel MPI tuning provided by GMAO
################################################################################
## export I_MPI_FALLBACK=0 # no longer supported?
 export I_MPI_FABRICS=shm:ofi
#export I_MPI_FABRICS=ofi
export I_MPI_SHM_HEAP_VSIZE=512
export PSM2_MEMORY=large
export I_MPI_EXTRA_FILESYSTEM=1
export I_MPI_EXTRA_FILESYSTEM_FORCE=gpfs
export I_MPI_OFI_PROVIDER=psm3
export I_MPI_ADJUST_SCATTER=2
export I_MPI_ADJUST_SCATTERV=2
export I_MPI_ADJUST_GATHER=2
export I_MPI_ADJUST_GATHERV=3
export I_MPI_ADJUST_ALLGATHER=3
export I_MPI_ADJUST_ALLGATHERV=3
export I_MPI_ADJUST_ALLREDUCE=12
export I_MPI_ADJUST_REDUCE=10
export I_MPI_ADJUST_BCAST=11
export I_MPI_ADJUST_REDUCE_SCATTER=4
export I_MPI_ADJUST_BARRIER=9

################################################################################
# OpenMPI tuning provided by GMAO
################################################################################
#export OMPI_MCA_shmem_mmap_enable_nfs_warning=0
#export OMPI_MCA_mpi_preconnect_all=1
#export OMPI_MCA_coll_tuned_bcast_algorithm=7
#export OMPI_MCA_coll_tuned_scatter_algorithm=2
#export OMPI_MCA_coll_tuned_reduce_scatter_algorithm=3
#export OMPI_MCA_coll_tuned_allreduce_algorithm=3
#export OMPI_MCA_coll_tuned_allgather_algorithm=4
#export OMPI_MCA_coll_tuned_allgatherv_algorithm=3
#export OMPI_MCA_coll_tuned_gather_algorithm=1
#export OMPI_MCA_coll_tuned_barrier_algorithm=0
#export OMPI_MCA_coll_tuned_use_dynamic_rules=1
#export OMPI_MCA_sharedfp="^lockedfile,individual"

APPDIR="${BASEDIR}/apps/osu-micro-benchmarks-7.2/${CC_VERSION}-${MPI_VERSION}/libexec/osu-micro-benchmarks/mpi"

for OSUBENCH in osu_allgather osu_allgatherv osu_allreduce osu_bcast osu_gather osu_gatherv osu_reduce osu_reduce_scatter osu_scatter osu_scatterv
do
  START=$(date +%s)
  RESULT=$( mpirun ${MPI_MODULE_OPTS} ${APPDIR}/collective/${OSUBENCH} -x ${ITERATIONS} -m ${MESSAGESIZE} -f | egrep -v '^$|^#' | sed -r 's/\s+/,/g' )
  END=$(date +%s)
  ELAPSED=$(($END-$START))
  echo "${OSUBENCH},${CC_VERSION},${MPI_VERSION},${MPI_TUNING},${SLURM_NNODES},${SLURM_NTASKS_PER_NODE},${SLURM_NTASKS},${RESULT},${ELAPSED}"
  echo "${OSUBENCH},${CC_VERSION},${MPI_VERSION},${MPI_TUNING},${SLURM_NNODES},${SLURM_NTASKS_PER_NODE},${SLURM_NTASKS},${RESULT},${ELAPSED}" >> ${RESULTSDIR}/results-${MPI_VERSION}.csv

# mpirun ${MPI_MODULE_OPTS} ${APPDIR}/collective/${OSUBENCH} -x ${ITERATIONS} -m ${MESSAGESIZE} -f

done

for OSUBENCH in osu_barrier
do
  START=$(date +%s)
  RESULT=$( mpirun ${MPI_MODULE_OPTS} ${APPDIR}/collective/${OSUBENCH} -x ${ITERATIONS} -f | egrep -v '^$|^#' | sed -r 's/\s+/,/g' )
  END=$(date +%s)
  ELAPSED=$(($END-$START))
  echo "${OSUBENCH},${CC_VERSION},${MPI_VERSION},${MPI_TUNING},${SLURM_NNODES},${SLURM_NTASKS_PER_NODE},${SLURM_NTASKS},${RESULT},${ELAPSED}"
  echo "${OSUBENCH},${CC_VERSION},${MPI_VERSION},${MPI_TUNING},${SLURM_NNODES},${SLURM_NTASKS_PER_NODE},${SLURM_NTASKS},${RESULT},${ELAPSED}" >> ${RESULTSDIR}/results-${MPI_VERSION}.csv

# mpirun ${MPI_MODULE_OPTS} ${APPDIR}/collective/${OSUBENCH} -x ${ITERATIONS} -f

done