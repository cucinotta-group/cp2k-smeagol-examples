#! /bin/bash

for folder in */ ; do
        echo "$folder"
        cd $folder
        rm slurm-*; sbatch run.slurm
        cd ..
done

