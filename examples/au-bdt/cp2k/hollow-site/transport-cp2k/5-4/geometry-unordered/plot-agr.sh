#!/bin/bash

mkdir output

file=0.smeagol_project_TRC.agr

rm output/G0-S0.out output/G1-S0.out output/G1-S2.out output/G2-S0.out output/G3-S0.out
sed -n '/G0.S0/,/G1.S0/p' $file > output/G0-S0.out
sed -n '/G1.S0/,/G1.S2/p' $file > output/G1-S0.out
sed -n '/G1.S2/,/G2.S0/p' $file > output/G1-S2.out
sed -n '/G2.S0/,/G3.S0/p' $file > output/G2-S0.out
sed -n '/G3.S0/,/&/p' $file > output/G3-S0.out

cd output
python /Volumes/Storage/Data/Work/Postdoc/Work/Python/smeagol-scripts/scripts/print-agr-here.py 
