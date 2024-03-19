#!/bin/bash
#PBS -l walltime=06:00:00
###PBS -l select=8:ncpus=64:mpiprocs=64:mem=200gb
#PBS -l select=8:ncpus=64:mpiprocs=32:ompthreads=2:mem=200gb

cd $PBS_O_WORKDIR
module purge

export OMP_NUM_THREADS=2
export MKL_NUM_THREADS=2

find . -maxdepth 1 ! -name 'run.slurm' -type f -exec rm  {} +
cp input/* .

module load CP2K/2022.1-foss-2022a

# Default CP2K 2022.1
#cp2k=/gpfs/easybuild/prod/software/CP2K/2022.1-foss-2022a/bin/cp2k.psmp

# CP2K official
#cp2k=/gpfs/home/cahart/software/cp2k-master/exe/local/cp2k.psmp
#cp2k=/gpfs/home/cahart/software/cp2k-2022.1/exe/local/cp2k.psmp
#cp2k=/gpfs/home/cahart/software/cp2k-2022.2/exe/local/cp2k.psmp

# CP2K-SMEAGOL
#cp2k=/gpfs/home/cahart/software/smeagol/cp2k-smeagol/cp2k-private/exe/local/cp2k.psmp
cp2k=/gpfs/home/cahart/software/smeagol/cp2k-smeagol/cp2k-private-external-blas/exe/local/cp2k.psmp

find . -maxdepth 1 ! -name '*slurm*' -type f -exec rm  {} +
cp input/* .

kpoints_bulk="2 4 20"
kpoints_em="2 4 1"

sed -i -e "s/KPOINTS_REPLACE/$kpoints_bulk/g"  1_bulkLR.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  2_dft_wfn.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  3_0V.inp
sed -i -e "s/KPOINTS_REPLACE/$kpoints_em/g"  4_V.inp

bulk_folder=/gpfs/home/cahart/transport/melamine/au_from-h2/leads/leads-sz_kpoints-2-4-20
cp $bulk_folder/*bulk* .
wait

#dft_folder=/gpfs/home/cahart/transport/melamine/au_size-6-6-6/capacitor/dft_kpoints-1-1-20
#cp $dft_folder/*dft* .
#wait

restart_file=/gpfs/home/cahart/transport/melamine/au_from-h2/iv-curve/single-point/ts2-guess-7A/iv_curve/V_0.5/0.5V-RESTART_0.kp
cp $restart_file .

HLB="$(grep '0.0000000000' bulk-VH_AV.dat | head -1 | awk '{print $2}')"

#sed -i -e "s/HLB_REPLACE/${HLB}/g"  3_0V.inp
#mpirun $cp2k -i 3_0V.inp -o log_3_0V.out

V=1.0
echo $V
mv 4_V.inp 4_${V}V.inp
sed -i -e "s/PROJECT_REPLACE/${V}V/g" 4_${V}V.inp
sed -i -e "s/HLB_REPLACE/${HLB}/g"  4_${V}V.inp
sed -i -e "s/V_REPLACE/${V}/g"  4_${V}V.inp

mpirun $cp2k -i 4_${V}V.inp -o log_4_${V}V.out
