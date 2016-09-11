#!/bin/bash
# Medición de rendimiento del algoritmo de planificación por turnos (Round Robin)
# @faustinoaq Sept, 2016

PC="[Intel Celeron 2597U]"

benchmark() {
  echo "Intento $j: Preparando entorno..."
  rm -f *.txt
  sleep 1
  /bin/time -a -o "_rb.dat" -f "$j,%e,%M,%P" ruby RoundRobin.rb $N $Q
  /bin/time -a -o "_py.dat" -f "$j,%e,%M,%P" python __pycache__/RoundRobin.cpython-35.pyc $N $Q
  /bin/time -a -o "_ja.dat" -f "$j,%e,%M,%P" java RoundRobin $N $Q
  /bin/time -a -o "_cr.dat" -f "$j,%e,%M,%P" ./RoundRobin $N $Q  
  sleep 1
}

temp_plot() {
  echo "set terminal png size 1024,700 enhanced font 'Source Code Pro,10'" > tmp.plt
  echo "set output '__$1.png'" >> tmp.plt
  echo "set title \"Algoritmo RoundRobin N=$N Q=$Q I=100 $PC\n$2 vs $3\"" >> tmp.plt
  echo "set ylabel '$2'" >> tmp.plt
  echo "set xlabel '$3'" >> tmp.plt
  echo "set offset 0.01,0.1,0,0" >> tmp.plt
  echo "set datafile separator ','" >> tmp.plt
  if [[ $4 -eq "1" ]]
  then
    echo "plot '_rb.dat' u $4:$5:$5 w labels of char 1,1 notitle, '' u $4:$5 w lp t 'Ruby',\\" >> tmp.plt 
    echo "'_py.dat' u $4:$5:$5 w labels of char 1,1 notitle, '' u $4:$5 w lp t 'Python',\\" >> tmp.plt
    echo "'_ja.dat' u $4:$5:$5 w labels of char 1,1 notitle, '' u $4:$5 w lp t 'Java',\\" >> tmp.plt
    echo "'_cr.dat' u $4:$5:$5 w labels of char 1,1 notitle, '' u $4:$5 w lp t 'Crystal'" >> tmp.plt
  else
    echo "plot '_rb.dat' u $4:$5 w lp t 'Ruby',\\" >> tmp.plt
    echo "'_py.dat' u $4:$5 w lp t 'Python',\\" >> tmp.plt
    echo "'_ja.dat' u $4:$5 w lp t 'Java',\\" >> tmp.plt
    echo "'_cr.dat' u $4:$5 w lp t 'Crystal'" >> tmp.plt
  fi
  gnuplot -c tmp.plt
}

move_data() {
  mkdir -p "RR-P$N-Q$Q"
  mv *.dat *.png *.txt "RR-P$N-Q$Q"
}

for h in 1000 # Procesos
do
  N=$h
  for i in 30 # Quantum
  do
    Q=$i
    echo "Procesos=$N Quantum=$Q ..."
    for j in $(seq 1 5) # Intentos
    do
      benchmark
    done
    temp_plot "time" "Tiempo (s)" "Intentos" "1" "2"
    temp_plot "memory" "Memoria (Kb)" "Intentos" "1" "3"
    temp_plot "cpu" "CPU (%)" "Intentos" "1" "4"
    temp_plot "mem_time" "Memoria (Kb)" "Tiempo (s)" "2" "3"
    move_data
  done
done
