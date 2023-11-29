# bin/bash

for d in */ ; do
    echo "$d"
    grep 'Total F' $d/log_2_dft_wfn.out | head -1
    grep 'Total F' $d/log_2_dft_wfn.out | tail -1
done
