for i in `ls -d m[0-9]*`;
do
    bias=`echo $i|cut -c2-`
    for j in 1 -1;
    do
        if [ $j -eq 1 ]; then
            na=$bias
        else
            na=$i
        fi
        bias=`echo "$bias * $j" |bc -l` 
        printf "%8.3f" $bias
        sed -n '/omega/p' $na/800/freq/mx.log |tail -8 |awk -F "=" '{printf("%8.1f", $2);}'
        echo
    done
done
