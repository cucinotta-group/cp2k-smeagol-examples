#!/bin/bash

for folder in */; do
        echo $folder
	#cp /work/e05/e05/cahart/postdoc/transport/cp2k-smeagol-examples/au-bdt/cp2k-smeagol/bulkkpoints-4-4-20/input/bulk.xyz $folder/input/bulk.xyz
	#cp -r md_dft_standard/input  $folder/
	cd $folder
	rm slurm-*; sbatch run.slurm
	cd ..
done
