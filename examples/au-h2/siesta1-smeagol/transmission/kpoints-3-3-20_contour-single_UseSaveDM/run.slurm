#!/bin/bash -l

#$ -l h_rt=24:00:0
#$ -l mem=4.6G
#$ -N test
#$ -pe mpi 64
#$ -cwd
#$ -P Gold
#$ -A Imperial_Chem

# SMEAGOL Ivan Rungger
smeagol=/home/mmm1169/Scratch/code/smeagol/siesta-smeagol/Src/smeagol-1.2_csg
#smeagol=/home/mmm1169/Scratch/code/smeagol/siesta-ivan/siesta-smeagol-rungger-chris/Src/smeagol-1.2_csg

# SMEAGOL Alex Rocha
#smeagol=/home/mmm1169/Scratch/code/smeagol/siesta-alex2/Obj/smeagol_alex
#smeagol=/home/mmm1169/Scratch/code/smeagol/siesta4-smeagol-rocha/Obj/siesta

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
sed -i -e '/em_struct/{r em.siesta' -e 'd}'   3_0V.fdf
sed -i -e '/em_struct/{r em.siesta' -e 'd}'   4_V.fdf
sed -i -e "s/bulk_atoms/$atoms_bulk/g"  1_bulkLR.fdf
sed -i -e "s/em_atoms/$atoms_em/g"  2_dft_wfn.fdf
sed -i -e "s/em_atoms/$atoms_em/g"  3_0V.fdf
sed -i -e "s/em_atoms/$atoms_em/g"  4_V.fdf

kpoints_bulk="20"
kpoints_em="3"
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  1_bulkLR.fdf
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  2_dft_wfn.fdf
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  3_0V.fdf
sed -i -e "s/K_REPLACE_BULK/$kpoints_bulk/g"  4_V.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  1_bulkLR.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  2_dft_wfn.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  3_0V.fdf
sed -i -e "s/K_REPLACE_EM/$kpoints_em/g"  4_V.fdf

#mpirun $smeagol  <1_bulkLR.fdf > log_1-bulkLR.out 2> err_1_bulkLR.out
folder_bulk=/home/mmm1169/Scratch/work/cp2k-smeagol-examples/au-h2/siesta1-smeago/leads/kpoints-3-3-20_omp-1_cores-20
cp $folder_bulk/*bulk* . 

export PATH=$PATH:/home/mmm1169/Scratch/code/other/bin:$PATH
pot.sh
HLB="$(grep '0.000  '  0.bulk-VH_AV.dat | awk '{print $2}')"
sed -i -e "s/HLB_REPLACE/${HLB}/g"  3_0V.fdf

#mpirun $smeagol  <2_dft_wfn.fdf > log_2_dft_wfn.out 2>err_2_dft_wfn.out
folder_dft=/home/mmm1169/Scratch/work/cp2k-smeagol-examples/au-h2/siesta1-smeago/dft/kpoints-3-3-20
cp $folder_dft/dft_wfn.DM .
cp dft_wfn.DM 0V.DM 

mpirun $smeagol  <3_0V.fdf > log_3_0V.out 2>err_3_0V.out

V=1.9
echo $V
mv 4_V.fdf 4_${V}V.fdf
sed -i -e "s/PROJECT_REPLACE/${V}V/g" 4_${V}V.fdf
sed -i -e "s/HLB_REPLACE/${HLB}/g"  4_${V}V.fdf
sed -i -e "s/V_REPLACE/${V}/g"  4_${V}V.fdf
cp 0V.DM ${V}V.DM

mpirun $smeagol  <4_${V}V.fdf > log_4_${V}V.out 2>err_4_${V}V.out

pot.sh
