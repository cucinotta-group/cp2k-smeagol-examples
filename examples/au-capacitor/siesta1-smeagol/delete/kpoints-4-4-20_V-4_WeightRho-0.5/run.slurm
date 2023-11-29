#!/bin/bash -l

#$ -l h_rt=01:00:0
#$ -l mem=4.6G
#$ -N test
#$ -pe mpi 64
#$ -cwd
#$ -P Gold
#$ -A Imperial_Chem

smeagol=/home/mmm1169/Scratch/code/smeagol/siesta-smeagol/Src/smeagol-1.2_csg

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
export OMP_NUM_THREADS=1
cp input/* .

kpoints_bulk="20"
kpoints_em="4"

sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  1_bulkLR.fdf
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  2_dft_wfn.fdf
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  3_0V.fdf
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g" 4_V.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  1_bulkLR.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  2_dft_wfn.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  3_0V.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  4_V.fdf

mpirun $smeagol  <1_bulkLR.fdf > log_1-bulkLR.out 2> err_1_bulkLR.out
#cp /home/mmm1169/Scratch/work/transport/au-bdt/3x3/kpoints/bulk_layers-4/transmission/exp/capacitor/benchmarking/bulk/layers-1-2-3-4/kpoints-4-4-20_hlb-auto_cores-20/*bulk* .
export PATH=$PATH:/home/mmm1169/Scratch/code/other/bin:$PATH 
pot.sh
HLB="$(grep '0.000  '  0.bulk-VH_AV.dat | awk '{print $2}')"
sed -i -e "s/HLB_REPLACE/${HLB}/g"  3_0V.fdf
sed -i -e "s/HLB_REPLACE/${HLB}/g"  4_V.fdf

mpirun $smeagol  <2_dft_wfn.fdf > log_2_dft_wfn.out 2>err_2_dft_wfn.out
mpirun $smeagol  <3_0V.fdf > log_3_0V.out 2>err_3_0V.out

V=4
sed -i -e "s/V_REPLACE/${V}/g"  4_V.fdf
mpirun $smeagol  <4_V.fdf > log_4_V.out 2>err_4_V.out

