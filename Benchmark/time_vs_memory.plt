set terminal png size 1024,700 enhanced font "Source Code Pro,10"
set output 'time_vs_memory.png'

set title "Algoritmo Round Robin para 50 procesos [Intel Celeron 2597U]\nTiempo (s) vs Memoria (Kbytes)" 
set xlabel "Tiempo (s)"
set ylabel "Memoria (Kbytes)"
set offset 0.01,0.1,0,0
set datafile separator ","

plot 'ruby.dat' u 2:3 t 'Ruby',\
     'python.dat' u 2:3 t 'Python',\
     'java.dat' u 2:3 t 'Java',\
     'crystal.dat' u 2:3 t 'Crystal'
