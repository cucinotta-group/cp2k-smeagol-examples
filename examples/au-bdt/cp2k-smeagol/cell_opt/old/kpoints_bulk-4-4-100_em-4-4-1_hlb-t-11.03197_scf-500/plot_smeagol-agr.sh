#!/bin/bash

mkdir output

file=*_TRC.agr

rm output/G0-S0.out output/G1-S0.out output/G1-S2.out output/G2-S0.out output/G3-S0.out
sed -n '/G0.S0/,/G1.S0/p' $file > output/G0-S0.out
sed -n '/G1.S0/,/G1.S2/p' $file > output/G1-S0.out
sed -n '/G1.S2/,/G2.S0/p' $file > output/G1-S2.out
sed -n '/G2.S0/,/G3.S0/p' $file > output/G2-S0.out
sed -n '/G3.S0/,/&/p' $file > output/G3-S0.out

cd output
/Users/chris/opt/anaconda3/envs/python3.7-mayavi/bin/python /Volumes/ELEMENTS/Storage/Postdoc/Data/Work/Postdoc/Work/Python/scripts/python/print-agr-here.py 

#open transmission.png
#open transmission_emdos.png
#open plot_all.png
