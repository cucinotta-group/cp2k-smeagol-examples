#!/bin/bash -l

#$ -l h_rt=01:00:0
#$ -l mem=4.6G
#$ -N test
#$ -pe mpi 2
#$ -cwd
#$ -P Gold
#$ -A Imperial_Chem

#smeagol=/home/mmm1169/Scratch/code/smeagol/siesta-smeagol/Src/smeagol-1.2_csg
smeagol=/home/mmm1169/Scratch/code/smeagol/siesta4-smeagol-rocha/Obj/siesta

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
export OMP_NUM_THREADS=1
cp input/* .

# Replace structures (siesta does not seem able to load from external file)
bulk=$( cat bulk.siesta)
atoms_bulk=$( wc -l < bulk.siesta)
em=$( cat em.siesta)
atoms_em=$( wc -l < em.siesta)
sed -i -e '/bulk_struct/{r bulk.siesta' -e 'd}'  1_bulkLR.fdf
sed -i -e '/em_struct/{r em.siesta' -e 'd}'   2-1_dft_wfn.fdf
sed -i -e '/em_struct/{r em_displace.siesta' -e 'd}'   2-2_dft_wfn.fdf
sed -i -e '/em_struct/{r em.siesta' -e 'd}'   3-1_0V.fdf
sed -i -e '/em_struct/{r em_displace.siesta' -e 'd}'   3-2_0V.fdf
sed -i -e "s/bulk_atoms/$atoms_bulk/g"  1_bulkLR.fdf
sed -i -e "s/em_atoms/$atoms_em/g"  2-1_dft_wfn.fdf
sed -i -e "s/em_atoms/$atoms_em/g"  2-2_dft_wfn.fdf
sed -i -e "s/em_atoms/$atoms_em/g"  3-1_0V.fdf
sed -i -e "s/em_atoms/$atoms_em/g"  3-2_0V.fdf

kpoints_bulk="20"
kpoints_em="2"
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  1_bulkLR.fdf
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  2-1_dft_wfn.fdf
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  3-1_0V.fdf
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  2-2_dft_wfn.fdf
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  3-2_0V.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  1_bulkLR.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  2-1_dft_wfn.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  3-1_0V.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  2-2_dft_wfn.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  3-2_0V.fdf

mpirun $smeagol  <1_bulkLR.fdf > log_1-bulkLR.out 2> err_1_bulkLR.out
export PATH=$PATH:/home/mmm1169/Scratch/code/other/bin:$PATH 
pot.sh
HLB="$(grep '0.000  '  bulk-VH_AV.dat | awk '{print $2}')"
sed -i -e "s/HLB_REPLACE/${HLB}/g"  3-1_0V.fdf
sed -i -e "s/HLB_REPLACE/${HLB}/g"  3-2_0V.fdf

mpirun $smeagol  <2-1_dft_wfn.fdf > log_2-1_dft_wfn.out 2>err_2-1_dft_wfn.out
mpirun $smeagol  <2-2_dft_wfn.fdf > log_2-2_dft_wfn.out 2>err_2-2_dft_wfn.out

mpirun $smeagol  <3-1_0V.fdf > log_3-1_0V.out 2>err_3-1_0V.out
mpirun $smeagol  <3-2_0V.fdf > log_3-2_0V.out 2>err_3-2_0V.out

