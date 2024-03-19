#!/bin/bash

script=extract_energy.sh
  
for folder in */; do
                work_dir=${folder}
                echo $work_dir
                cd $work_dir
                cp ../$script .
                ./$script
               cd ..
done

