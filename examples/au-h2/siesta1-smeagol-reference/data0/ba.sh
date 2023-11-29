
for i in `ls -d [0-9]*`;do
    printf "%6.2f" $i
    for j in {61..62};do
        k=`echo $j - 1 |bc`
        l=`echo $j + 1 |bc`
        bangle.sh $i/opt/mx.log $k $j $l |awk '{printf("%9.2f",$1)}'
    done
    echo
done

