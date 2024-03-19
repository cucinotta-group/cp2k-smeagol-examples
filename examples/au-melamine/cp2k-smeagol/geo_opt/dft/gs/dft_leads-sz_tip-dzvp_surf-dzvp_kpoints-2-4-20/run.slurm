#!/bin/bash
#PBS -l walltime=00:30:00
#PBS -l select=8:ncpus=64:mpiprocs=64:mem=200gb
###PBS -l select=8:ncpus=64:mpiprocs=8:ompthreads=8:mem=200gb

cd $PBS_O_WORKDIR
module purge

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1

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

mpirun $cp2k -i 2_dft_wfn.inp -o log_2_dft_wfn.out
