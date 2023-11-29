#! /bin/bash

input=log_opt.out
output_1=pos.siesta
output_2=final.siesta

atoms="$(grep 'NumberOfAtoms' $input | awk '{print $2}')"

grep -A $atoms '(Ang):' $input > $output_1
tail -n $atoms $output_1 > $output_2
