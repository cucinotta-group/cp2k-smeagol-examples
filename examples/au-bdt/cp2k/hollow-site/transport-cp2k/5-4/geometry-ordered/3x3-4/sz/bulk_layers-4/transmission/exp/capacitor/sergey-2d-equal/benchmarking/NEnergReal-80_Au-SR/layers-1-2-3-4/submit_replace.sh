#!/bin/bash

input="#SBATCH -t 24:00:00"
output="#SBATCH -t 02:00:00"

file_1="submit.slurm"

for folder in */; do
	echo $folder
	sed -i -e "s/$input/$output/g"  $folder/$file_1
done
