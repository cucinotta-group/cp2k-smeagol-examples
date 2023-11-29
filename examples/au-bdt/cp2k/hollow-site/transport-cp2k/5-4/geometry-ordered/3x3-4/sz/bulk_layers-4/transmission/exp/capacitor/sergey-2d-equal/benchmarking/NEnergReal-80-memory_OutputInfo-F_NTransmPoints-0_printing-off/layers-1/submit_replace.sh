#!/bin/bash

#input="#SBATCH -t 24:00:00"
#output="#SBATCH -t 02:00:00"

#input_raw="/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private/exe/local/cp2k.psmp"
#input=$(printf '%s\n' "$input_raw" | sed -e 's/[\/&]/\\&/g')
#echo $input

#output_raw="/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private-sergey-3/exe/local/cp2k.psmp"
#output=$(printf '%s\n' "$output_raw" | sed -e 's/[\/&]/\\&/g')
#echo $output

input_raw="/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private-sergey-3/exe/local/cp2k.psmp"
input=$(printf '%s\n' "$input_raw" | sed -e 's/[\/&]/\\&/g')
echo $input

output_raw="/work4/cse/scarf1157/work/code/smeagol/cp2k-smeagol/scarf21/smgl/cp2k-private-sergey-4/exe/local/cp2k.psmp"
output=$(printf '%s\n' "$output_raw" | sed -e 's/[\/&]/\\&/g')
echo $output

file_1="submit.slurm"

for folder in */; do
	echo $folder
	sed -i -e "s/$input/$output/g"  $folder/$file_1
done
