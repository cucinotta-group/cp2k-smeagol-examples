#!/bin/bash

num_lines=185
opt_traj_file="opt-traj.xyz"
rm $opt_traj_file

for input_file in 2_dft_wfn-pos-Replica_nr_*-1.xyz; do
    output_file="opt-${input_file#*-}"
    echo $input_file
    echo $output_file
    
    # Output final geometry
    tail -n $num_lines "$input_file" > "$output_file"

    # Append the content of each struct-*.xyz file to opt-traj.xyz
    cat "$output_file" >> "$opt_traj_file"
done

grep 'E =   ' opt-traj.xyz
