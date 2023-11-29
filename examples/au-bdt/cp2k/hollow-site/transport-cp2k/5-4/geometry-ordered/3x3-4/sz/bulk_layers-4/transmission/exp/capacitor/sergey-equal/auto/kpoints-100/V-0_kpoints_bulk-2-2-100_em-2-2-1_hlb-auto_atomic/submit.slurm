#!/usr/bin/env bash

#SBATCH -n 240
#SBATCH --exclusive 
#SBATCH -C  "scarf21"
#SBATCH -t 24:00:00

module purge
module load GCC/10.3.0 OpenMPI/4.1.1-GCC-10.3.0 OpenBLAS/0.3.15-GCC-10.3.0

# Sergey branch
#cp2k=/home/vol07/scarf1157/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private/exe/local/cp2k.psmp
cp2k=/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private/exe/local/cp2k.psmp

# Chris branch 1
#cp2k=/home/vol07/scarf1157/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private-chris-1/exe/local/cp2k.psmp
#cp2k=/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private-chris-1/exe/local/cp2k.psmp
#cp2k=/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private-chris-2/exe/local/cp2k.psmp

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
export OMP_NUM_THREADS=1
cp input/* .

mpirun $cp2k -i 1_bulkLR.inp -o log_1-bulkLR.out
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
