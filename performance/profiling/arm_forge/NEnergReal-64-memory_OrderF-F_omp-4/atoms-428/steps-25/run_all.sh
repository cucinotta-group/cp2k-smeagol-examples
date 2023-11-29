#! /bin/bash

for folder in */ ; do
        echo "$folder"
        cd $folder
        #cp ../*xyz* input/
        rm slurm-*; sbatch submit.slurm
        cd ..
done
