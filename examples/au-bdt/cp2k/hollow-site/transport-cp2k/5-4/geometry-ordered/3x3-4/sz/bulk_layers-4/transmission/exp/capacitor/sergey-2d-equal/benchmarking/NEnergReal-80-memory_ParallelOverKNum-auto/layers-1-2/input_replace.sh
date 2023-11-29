#!/bin/bash

#input="#DEBUG_HARTREE_ENERGY_UNITS .true."
#output="EM.ParallelOverKNum 2"

input="EM.ParallelOverKNum 2"
output="EM.ParallelOverKNum -1"

file_1="input/1_bulkLR.inp "

#input="MAX_SCF   500"
#output="MAX_SCF   5"

#input="NEnergReal               640"
#output="NEnergReal               80"

#input="# Other variables"
#output="EM.ParallelOverKNum 2"

#input="EM.ParallelOverKNum 2"
#output="EM.ParallelOverKNum -1"

#file_1="input/3_0V.inp"
#file_2="input/4_V.inp"

for folder in */; do
	echo $folder
	#cp -r /work4/cse/scarf1157/work/testing/cp2k-smeagol/bdt/cp2k/hollow-site/transport-cp2k/5-4/geometry-ordered/3x3-4/sz/bulk_layers-4/transmission/exp/capacitor/sergey-2d-equal/layers-1/kpoints-1-1-20_hlb-auto/input $folder/
	sed -i -e "s/$input/$output/g"  $folder/$file_1
	#sed -i -e "s/$input/$output/g"  $folder/$file_2
done
