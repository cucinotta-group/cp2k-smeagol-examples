#!/bin/bash

input="MAX_SCF   500"
output="MAX_SCF   5"

file_1="input/3_0V.inp"
file_2="input/4_V.inp"

for folder in */; do
	echo $folder
	sed -i -e "s/$input/$output/g"  $folder/$file_1
	sed -i -e "s/$input/$output/g"  $folder/$file_2
done
