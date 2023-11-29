#!/bin/bash

#input="MAX_SCF   500"
#output="MAX_SCF   5"

#input="NEnergReal               640"
#output="NEnergReal               80"

#input="# Perform a transport calculation"
#output="EPS_PGF_ORB 0.0"

input="EPS_PGF_ORB 0.0"
output="EPS_PGF_ORB 1E-12"

file_1="input/3_0V.inp"
file_2="input/4_V.inp"

for folder in */; do
	echo $folder
	#cp -r /work4/cse/scarf1157/work/testing/cp2k-smeagol/bdt/cp2k/hollow-site/transport-cp2k/5-4/geometry-ordered/3x3-4/sz/bulk_layers-4/transmission/exp/capacitor/sergey-2d-equal/layers-1/kpoints-1-1-20_hlb-auto/input $folder/
	sed -i -e "s/$input/$output/g"  $folder/$file_1
	sed -i -e "s/$input/$output/g"  $folder/$file_2
done
