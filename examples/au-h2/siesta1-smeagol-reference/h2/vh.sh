
tf=tmp.999999
if [ -f $tf ]; then
    echo "Temporary file $tf exists."
    exit 1
fi

printf "%10.3f" 0.0 >>$tf
awk '{printf("%10.3f", $1)}' 0.0/opt/0.mol-VH_AV.dat >>$tf
echo >>$tf

for i in `ls -d [0-9]*`;do
    printf "%6.3f" $i >>$tf
    awk '{printf("%10.3f", $2)}' $i/opt/0.mol-VH_AV.dat >>$tf
    echo >>$tf
done

transpose.sh $tf >vh.txt
rm $tf

