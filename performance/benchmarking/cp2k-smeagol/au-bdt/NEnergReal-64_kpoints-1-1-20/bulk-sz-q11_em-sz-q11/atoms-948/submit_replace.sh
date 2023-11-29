#!/bin/bash

#input="#SBATCH -t 24:00:00"
#output="#SBATCH -t 02:00:00"

#input_raw="/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private/exe/local/cp2k.psmp"
input_raw="bulk_folder=/work/e05/e05/cahart/postdoc/transport/cp2k-smeagol-examples/benchmarking/cp2k-smeagol/au-bdt/NEnergReal-64_kpoints-1-1-20/atoms-428/bulk_dft"
input=$(printf '%s\n' "$input_raw" | sed -e 's/[\/&]/\\&/g')
#input="tasks-per-node=128"
#input="OMP_NUM_THREADS=1"
echo $input

#output_raw="/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private-sergey-3/exe/local/cp2k.psmp"
output_raw="bulk_folder=/work/e05/e05/cahart/postdoc/transport/cp2k-smeagol-examples/benchmarking/cp2k-smeagol/au-bdt/NEnergReal-64_kpoints-1-1-20/atoms-948/bulk_dft"
output=$(printf '%s\n' "$output_raw" | sed -e 's/[\/&]/\\&/g')
#output="tasks-per-node=64"
#output="OMP_NUM_THREADS=2"
echo $output

file_1="run.slurm"

for folder in */; do
	echo $folder
	sed -i -e "s/$input/$output/g"  $folder/$file_1
done
