#!/bin/bash -l

#$ -l h_rt=00:20:0
#$ -l mem=4.6G
#$ -N test
#$ -pe mpi 2
#$ -cwd
#$ -P Gold
#$ -A Imperial_Chem

smeagol=/home/mmm1169/Scratch/code/smeagol/siesta-smeagol/Src/smeagol-1.2_csg

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
export OMP_NUM_THREADS=1
cp input/* .

# Replace structures (siesta does not seem able to load from external file)
bulk=$( cat bulk.siesta)
atoms_bulk=$( wc -l < bulk.siesta)
em=$( cat em.siesta)
atoms_em=$( wc -l < em.siesta)
sed -i -e '/bulk_struct/{r bulk.siesta' -e 'd}'  1_bulkLR.fdf
sed -i -e '/em_struct/{r em.siesta' -e 'd}'   2_dft_wfn.fdf
sed -i -e '/em_struct/{r em.siesta' -e 'd}'   IV.fdf
sed -i -e "s/bulk_atoms/$atoms_bulk/g"  1_bulkLR.fdf
sed -i -e "s/em_atoms/$atoms_em/g"  2_dft_wfn.fdf
sed -i -e "s/em_atoms/$atoms_em/g"  IV.fdf

kpoints_bulk="20"
kpoints_em="2"
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  1_bulkLR.fdf
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  2_dft_wfn.fdf
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  IV.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  1_bulkLR.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  2_dft_wfn.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  IV.fdf

mpirun $smeagol  <1_bulkLR.fdf > log_1-bulkLR.out 2> err_1_bulkLR.out
export PATH=$PATH:/home/mmm1169/Scratch/code/other/bin:$PATH 
pot.sh
HLB="$(grep '0.000  '  0.bulk-VH_AV.dat | awk '{print $2}')"

mpirun $smeagol  <2_dft_wfn.fdf > log_2_dft_wfn.out 2>err_2_dft_wfn.out

V=($(seq -2 0.5 2))
VInitial="${V[0]}"
VFinal="${V[-1]}"
NIVPoints="${#V[@]}"
array=($(seq 1 "$NIVPoints"))

sed -i -e "s/HLB_REPLACE/${HLB}/g"  IV.fdf
sed -i -e "s/VInitial_REPLACE/$VInitial/g" IV.fdf
sed -i -e "s/VFinal_REPLACE/$VFinal/g" IV.fdf
sed -i -e "s/NIVPoints_REPLACE/$NIVPoints/g" IV.fdf
sed -i -e "s/VBlock_REPLACE/${array[*]}/g" IV.fdf

mpirun $smeagol  <IV.fdf > log_IV.out 2>err_IV.out

sed -i -e "s/D/E/g" IV.CUR
