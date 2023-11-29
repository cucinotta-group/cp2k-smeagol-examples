#! /bin/bash

for folder in */ ; do
        echo "$folder"
        cd $folder
        #cp ../*xyz* input/
        sbatch submit.slurm
        cd ..
done
