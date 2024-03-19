#!/bin/sh
#SBATCH -n 32
#SBATCH -t 24:00:00
#SBATCH -p compute
#SBATCH -U HPC_11_00128

source ~/.bashrc

srun --mpi=mvapich /home/other/ooto/bin/smeagol <input.fdf > smeagol.out

