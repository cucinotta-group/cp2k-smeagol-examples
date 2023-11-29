printf "%6s" "bias"
for i in {59..64};do
    printf "%9d" $i
done
echo

for i in `ls -d [0-9]*`;do
    printf "%6.2f" $i
    for j in {59..64};do
        getcoor.sh $i/800/opt/mx.log $j |awk '{printf("%9.3f",$3)}'
#        getcoor.sh $i/opt/mx.log $j
    done
    echo
done

