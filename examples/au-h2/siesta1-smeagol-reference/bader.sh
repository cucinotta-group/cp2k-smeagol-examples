
printf "%6d" 0 
for i in {55..68};do
    printf "%10d" $i
done
echo

for i in `ls -d [0-9]*`;do
    printf "%6.3f" $i 
    awk '{if (NR >56 && NR <71) printf("%10.3f", $5)}' $i/800/opt/ACF.dat
    echo 
done


