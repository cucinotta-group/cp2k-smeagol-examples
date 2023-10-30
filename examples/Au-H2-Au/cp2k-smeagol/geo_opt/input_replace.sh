#!/bin/bash

#input="NEnergReal               80"
#output="NEnergReal               64"

input="EM.ParallelOverKNum F"
output="EM.ParallelOverKNum F"

#output_raw="module load cp2k/cp2k-2023.1"
#output=$(printf '%s\n' "$output_raw" | sed -e 's/[\/&]/\\&/g')

file_1="input/1_bulkLR.inp"
file_2="input/2_dft_wfn.inp"
file_3="input/3_0V.inp"
file_4="input/4_V.inp"

for folder in */; do
        echo $folder
        #cp -r kpoints-2-2-20_hlb-auto_cores-120/input $folder/

        #sed -i -e "s/$input/$output/g"  $folder/$file_1
        #sed -i -e "s/$input/$output/g"  $folder/$file_2
        #sed -i -e "s/$input/$output/g"  $folder/$file_3
        #sed -i -e "s/$input/$output/g"  $folder/$file_4

	sed -i -e "s/$input/$output/g"  NEnergReal-64*/*/$file_4
	#sed -i -e "s/$input/$output/g"  NEnergReal-64*/*/run.slurm

        #echo 'EM.OrderN         F' >> $folder/$file_1
        #echo 'EM.OrderN         F' >> $folder/$file_2
done
