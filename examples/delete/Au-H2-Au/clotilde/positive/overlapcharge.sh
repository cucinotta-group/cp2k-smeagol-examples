printf "     "
for v in 0.0 0.5 1.0 1.2 1.4 1.5 1.6 1.7 1.9;do 
    printf "%8.3f" $v;
done
echo

for i in {59..64}; do
for j1 in {1..2}; do
j=`echo "$i+$j1"|bc`;
printf "%d-%d" $i $j;
for v in 0.0 0.5 1.0 1.2 1.4 1.5 1.6 1.7 1.9;do 
getpop.sh $v/800/coop/mx.log $i $j|tail -1 |awk '{printf("%8.3f",$1)}';
done;
echo;
done;
done 
