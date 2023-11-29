for i in `ls -d [0-9]*`;do
awk '
BEGIN{n=6;n1=2;n0=n+2;s1=s2=s10=s20=0;} 
{
   if (NR==n0+n1*n*6+4*n+n1+1 || NR==n0+n1*n*6+5*n+n1+1) {s1+=$3;}
   if (NR==n0+n1*n*6+4*n+n1+2 || NR==n0+n1*n*6+5*n+n1+2) {s1+=$3;s10+=$3;}

   if (NR==n0+(n1+1)*n*6+4*n+n1+1 || NR==n0+(n1+1)*n*6+5*n+n1+1) {s2+=$3;s20+=$3;}
   if (NR==n0+(n1+1)*n*6+4*n+n1+2 || NR==n0+(n1+1)*n*6+5*n+n1+2) {s2+=$3;}
}

END{printf("%8.3f %8.3f %8.3f %8.3f %8.3f    %8.3f\n",'"$i"', s1/2,s2/2,-s10/2,-s20/2, -(s10+s20)/4)}' $i/freq/mx.FC
done
