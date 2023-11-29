
for i in `ls -d [0-9]*`;do
    printf "%6.2f" $i
    for j in {60..62};do
        k=`echo $j + 1 |bc`
        blength.sh $i/opt/mx.log $j $k |awk '{printf("%9.3f",$1)}'
    done
    echo
done

