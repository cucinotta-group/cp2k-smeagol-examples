#!/bin/bash

#input="#SBATCH -t 24:00:00"
#output="#SBATCH -t 02:00:00"

input_raw="cp2k=/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private/exe/local/cp2k.psmp"
input=${input_raw//\//\\/}

output_raw="cp2k=/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private-sergey-2/exe/local/cp2k.psmp"
output=${output_raw//\//\\/}

file_1="submit.slurm"

for folder in */; do
	echo $folder
	sed -i -e "s/$input/$output/g"  $folder/$file_1
done
