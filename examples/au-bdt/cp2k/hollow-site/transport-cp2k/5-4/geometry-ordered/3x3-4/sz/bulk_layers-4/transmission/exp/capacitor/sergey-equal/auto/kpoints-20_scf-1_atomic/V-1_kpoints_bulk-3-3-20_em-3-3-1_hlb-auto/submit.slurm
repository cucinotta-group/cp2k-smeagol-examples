#!/usr/bin/env bash

#SBATCH -n 240
#SBATCH --exclusive 
#SBATCH -C  "scarf21"
#SBATCH -t 01:00:00

module purge
module load GCC/10.3.0 OpenMPI/4.1.1-GCC-10.3.0 OpenBLAS/0.3.15-GCC-10.3.0

# Sergey branch
#cp2k=/home/vol07/scarf1157/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private/exe/local/cp2k.psmp
cp2k=/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private/exe/local/cp2k.psmp

# Chris branch 1
#cp2k=/home/vol07/scarf1157/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private-chris-1/exe/local/cp2k.psmp
#cp2k=/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private-chris-1/exe/local/cp2k.psmp
#cp2k=/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private-chris-2/exe/local/cp2k.psmp

#find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
export OMP_NUM_THREADS=1
cp input/* .

kpoints_bulk="3 3 20"
kpoints_em="3 3 1"
scf=1
scf_guess=ATOMIC

sed -i -e "s/KPOINTS_REPLACE/$kpoints_bulk/g"  1_bulkLR.inp 
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  2_dft_wfn.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  3_0V.inp
sed -i -e "s/MAX_SCF   500/MAX_SCF $scf/g"  3_0V.inp
sed -i -e "s/SCF_GUESS RESTART/SCF_GUESS $scf_guess/g"  3_0V.inp

#mpirun $cp2k -i 1_bulkLR.inp -o log_1-bulkLR.out
#mpirun $cp2k -i 2_dft_wfn.inp -o log_2_dft_wfn.out

HLB="$(grep '0.0000000000' bulk-VH_AV.dat | awk '{print $2}')"
echo $HLB
sed -i -e "s/HLB_REPLACE/${HLB}/g"  3_0V.inp

mpirun $cp2k -i 3_0V.inp -o log_3_0V.out

name="$(grep 'PROJECT_NAME' 3_0V.inp | awk '{print $2}')"
scf_steps="$(grep ' *** SCF run converged in  ' log_3_0V.out | awk '{print $6}')"

rm -r output
mkdir output

cp "${name}-VH_z-00${scf_steps}.dat" output/${name}-VH_z.dat
cp "${name}-VH_z-00${scf_steps}.dat" ${name}-VH_z.dat
cp "${name}-RHO_z-00${scf_steps}.dat" output/${name}-RHO_z.dat
cp "${name}-RHO_z-00${scf_steps}.dat" ${name}-RHO_z.dat

rm *.txt
