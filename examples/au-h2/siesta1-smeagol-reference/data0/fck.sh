for i in `ls -d [0-9]*`;do
getk.sh $i/freq/mx.FC 6 3 4 3 | awk '{printf("%8.3f %10.5f %10.5f %10.5f\n",'"$i"', $5, $6, $7)}'
done
