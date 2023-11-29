for i in `ls -d [0-9]*`;
do
    printf "%8.3f" $i
    sed -n '/omega/p' $i/800/freq/mx.log |tail -8 |awk -F "=" '{printf("%8.1f", $2);}'
    echo
done
