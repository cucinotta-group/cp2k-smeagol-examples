#!/bin/bash

for folder in */; do
                work_dir=${folder}
                echo $work_dir
		cd $work_dir
		./analysis.sh
	       cd ..	
done
