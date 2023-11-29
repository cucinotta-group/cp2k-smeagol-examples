#!/usr/bin/env bash

#SBATCH -n 24
#SBATCH --exclusive 
#SBATCH -C  "scarf21"
#SBATCH -t 00:10:00

module purge
module load GCC/10.3.0 OpenMPI/4.1.1-GCC-10.3.0 OpenBLAS/0.3.15-GCC-10.3.0

export OMP_NUM_THREADS=1

rm WALLTIME; rm *.txt; rm *.out; rm *.DAT; rm *.kp*; rm *fort*; rm *DM*; rm *EDM*; rm *HST*; rm *CUR*, rm *TRC*

#cp2k=/home/vol07/scarf1157/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private/exe/local/cp2k.popt
cp2k=/home/vol07/scarf1157/code/cp2k/scarf21/cp2k/exe/local/cp2k.popt

mpirun $cp2k -i input.inp -o log.out

#mpirun $cp2k -i 1_bulkLR.inp -o log_1-bulkLR.out
#mpirun $cp2k -i 2_dft_wfn.inp -o log_2_dft_wfn.out
#mpirun $cp2k -i 3_0V.inp -o log_3_0V.out



