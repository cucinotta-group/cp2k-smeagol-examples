#!/bin/bash

#input="NEnergReal               640"
#output="NEnergReal               80"

#input="EM.OrderN         F"
#output="EM.OrderN         T"

#input="8.292"
#output="16.584"

#input="MAX_SCF   5"
#output="MAX_SCF   50"

input="MAX_SCF   50"
output="MAX_SCF   25"

file_1="input/1_bulkLR.inp"
file_2="input/2_dft_wfn.inp"
file_3="input/3_0V.inp"
file_4="input/4_V.inp"

for folder in */; do
        echo $folder
        #cp -r kpoints-2-2-20_hlb-auto_cores-120/input $folder/

        #sed -i -e "s/$input/$output/g"  $folder/$file_1
        sed -i -e "s/$input/$output/g"  $folder/$file_2
        sed -i -e "s/$input/$output/g"  $folder/$file_3
        sed -i -e "s/$input/$output/g"  $folder/$file_4

        #echo 'EM.OrderN         F' >> $folder/$file_1
        #echo 'EM.OrderN         F' >> $folder/$file_2
done

