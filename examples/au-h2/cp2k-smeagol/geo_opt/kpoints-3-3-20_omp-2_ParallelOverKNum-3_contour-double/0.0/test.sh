if grep -q 'GEOMETRY OPTIMIZATION COMPLETED' log_4_0.0V.out
then 
   echo "OK";
else
   echo "NOT OK";
fi
