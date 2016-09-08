set terminal png size 1024,700 enhanced font "Source Code Pro,10"
set output 'memory.png'

set title "Algoritmo Round Robin para 50 procesos [Intel Celeron 2597U]\nMemoria (Kbytes) vs Intentos" 
set xlabel "Intentos"
set ylabel "Memoria (Kbytes)"
set offset 1,2,0,0
set datafile separator ","

plot 'ruby.dat' u 1:3:3 w labels of char 1,1 notitle, '' u 1:3 w lp t 'Ruby',\
     'python.dat' u 1:3:3 w labels of char 1,1 notitle, '' u 1:3 w lp t 'Python',\
     'java.dat' u 1:3:3 w labels of char 1,1 notitle, '' u 1:3 w lp t 'Java',\
     'crystal.dat' u 1:3:3 w labels of char 1,1 notitle, '' u 1:3 w lp t 'Crystal'
