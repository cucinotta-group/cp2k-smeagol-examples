for i in `ls -d [0-9]*`; do printf "%5.2f" $i; sed -n '/omega/p' $i/freq/mx.log |tail -8 |awk -F "=" '{printf("%8.1f", $2);}'; echo;done

for i in `ls -d [0-9]*`; do printf "%5.2f" $i; for j in {59..64}; do getcoor.sh $i/opt/mx.log $j |awk '{printf("%16.8f", $3);}';done; echo;done |tee pos.txt
