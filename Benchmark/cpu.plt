set terminal png size 1024,700 enhanced font "Source Code Pro,10"
set output 'cpu.png'

set title "Algoritmo Round Robin para 50 procesos [Intel Celeron 2597U]\nCPU (%) vs Intentos" 
set xlabel "Intentos"
set ylabel "CPU (%)"
set offset 1,2,0,0
set datafile separator ","

plot 'ruby.dat' u 1:4:4 w labels of char 1,1 notitle, '' u 1:4 w lp t 'Ruby',\
     'python.dat' u 1:4:4 w labels of char 1,1 notitle, '' u 1:4 w lp t 'Python',\
     'java.dat' u 1:4:4 w labels of char 1,1 notitle, '' u 1:4 w lp t 'Java',\
     'crystal.dat' u 1:4:4 w labels of char 1,1 notitle, '' u 1:4 w lp t 'Crystal'
