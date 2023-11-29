#!/bin/bash

#input="NEnergReal               64"
#output="NEnergReal               0"

input="MAX_SCF   5"
output="MAX_SCF   3"

#input="NTransmPoints            800"
#output="NTransmPoints            1"

#input="EM.OrderN         F"
#output="EM.OrderN         T"

file_1="input/1_bulkLR.inp"
file_2="input/2_dft_wfn.inp"
file_3="input/3_0V.inp"
file_4="input/4_V.inp"

for folder in omp*/; do
        echo $folder
        #cp -r kpoints-2-2-20_hlb-auto_cores-120/input $folder/
	#cp -r /work/e05/e05/cahart/postdoc/transport/au-bdt/benchmarking/archer/benchmarking/NEnergReal-80-memory_OrderF-F/atoms-948/kpoints-1-1-20_hlb-auto_cores-128/input  $folder/

        #sed -i -e "s/$input/$output/g"  $folder/$file_1
        sed -i -e "s/$input/$output/g"  $folder/$file_2
        sed -i -e "s/$input/$output/g"  $folder/$file_3
        sed -i -e "s/$input/$output/g"  $folder/$file_4

        #echo 'EM.OrderN         F' >> $folder/$file_1
        #echo 'EM.OrderN         F' >> $folder/$file_2
done
