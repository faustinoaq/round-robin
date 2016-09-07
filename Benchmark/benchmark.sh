#!/usr/bin/bash

N=50
Q=1
I=5

for i in $(seq 1 $I)
do
  /usr/bin/time -a -o "ruby.dat" -f "$i %e %M %P" ruby RoundRobin.rb $N $Q
  /usr/bin/time -a -o "python.dat" -f "$i %e %M %P" python RoundRobin.py $N $Q
  /usr/bin/time -a -o "java.dat" -f "$i %e %M %P" java Java/RoundRobin $N $Q
  /usr/bin/time -a -o "crystal.dat" -f "$i %e %M %P" ./RoundRobin $N $Q
done

gnuplot -c Benchmark/benchmark.plt
display benchmark.png
