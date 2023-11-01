#!/bin/bash
  
input=("log_2-1_dft_wfn.out" "log_3-1_0V.out")
output=("data_2-1.out" "data_3-1.out")

for folder in */ ; do
                work_dir=${folder}
                echo $work_dir

                for k in "${!input[@]}"; do

                        atoms="$(grep 'NumberOfAtoms' $work_dir/${input[$k]} | awk '{print $2}')"

                        rm $work_dir/${output[$k]}
			            grep -A ${atoms} "siesta: Atomic forces"  ${search} $work_dir/${input[$k]} | head -n$((atoms+1)) | tail -n${atoms} > $work_dir/${output[$k]} 

	done
done

input=( "log_2-2_dft_wfn.out" "log_3-2_0V.out")
output=( "data_2-2.out"  "data_3-2.out")

for folder in */ ; do
                work_dir=${folder}
                echo $work_dir

                for k in "${!input[@]}"; do

                        atoms="$(grep 'NumberOfAtoms' $work_dir/${input[$k]} | awk '{print $2}')"

                        rm $work_dir/${output[$k]}
                        grep -A ${atoms}  "siesta: Constrained forces" $work_dir/${input[$k]} | head -n$((atoms+1)) | tail -n${atoms} > $work_dir/${output[$k]}

    done
done
