#!/usr/bin/env bash

#SBATCH -n 24
#SBATCH --exclusive 
#SBATCH -C  "scarf21"
#SBATCH -t 00:30:00

module purge
module load GCC/10.3.0 OpenMPI/4.1.1-GCC-10.3.0 OpenBLAS/0.3.15-GCC-10.3.0

cp2k=/home/vol07/scarf1157/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private/exe/local/cp2k.psmp

export OMP_NUM_THREADS=1

mpirun $cp2k -i input.inp -o log.out

