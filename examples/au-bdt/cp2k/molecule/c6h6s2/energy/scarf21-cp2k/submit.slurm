#!/usr/bin/env bash

#SBATCH -n 24
#SBATCH --exclusive 
#SBATCH -C  "scarf21"
#SBATCH -t 00:30:00

module purge
module load OpenMPI/4.1.1-GCC-10.3.0

export          I_MPI_FABRICS=shm:ofi
export          I_MPI_SHM_OPT=shm
export          I_MPI_OFI_LIBRARY_INTERNAL=1
export          FI_PROVIDER=verbs
export          FI_PROVIDER_PATH    

source /home/vol07/scarf1157/code/cp2k/scarf21/cp2k/tools/toolchain/install/setup
cp2k=/home/vol07/scarf1157/code/cp2k/scarf21/cp2k/exe/local/cp2k.psmp

export OMP_NUM_THREADS=1
mpirun $cp2k -i input.inp -o log.out
