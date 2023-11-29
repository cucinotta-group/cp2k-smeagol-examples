for i in `ls -d [0-9]*`;do
awk 'BEGIN{s1=s2=s10=s20=0;} {if (NR>=13 && NR<=16) s1+=$3; if (NR ==14 || NR==16) s10+=$3; if (NR>=25 && NR<=28) s2+=$3; if (NR==25 || NR==27) s20+=$3;} END{printf("%8.3f %8.3f %8.3f %8.3f %8.3f    %8.3f\n",'"$i"', s1/2,s2/2,-s10/2,-s20/2, -(s10+s20)/4)}' $i/freq/less/mx.FC
done
