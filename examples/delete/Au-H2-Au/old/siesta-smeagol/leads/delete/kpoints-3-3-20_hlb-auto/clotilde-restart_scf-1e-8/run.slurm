#!/bin/bash -l

#$ -l h_rt=01:00:0
#$ -l mem=4.6G
#$ -N siesta
#$ -pe mpi 40
#$ -cwd
#$ -P Gold
#$ -A Imperial_Chem

smeagol=/home/mmm1169/Scratch/code/smeagol/siesta-smeagol/Src/smeagol-1.2_csg
export OMP_NUM_THREADS=1

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
cp input/* .

leads_dir=/home/mmm1169/Scratch/work/transport/AuH2/clotilde/lead
cp $leads_dir/*DAT* .
cp $leads_dir/*HST* .
cp $leads_dir/*DM* .

mpirun $smeagol  <1_bulkLR.fdf > log_1-bulkLR.out 2> err_1_bulkLR.out
#mpirun $smeagol  <2_dft_wfn.fdf > log_2_dft_wfn.out 2>err_2_dft_wfn.out
#mpirun $smeagol  <3_0V.fdf > log_3_0V.out 2>err_3_0V.out

