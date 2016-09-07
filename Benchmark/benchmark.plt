set terminal png size 1024,600 enhanced font "Source Code Pro,10"
set output 'benchmark.png'

set title "Benchmark para N procesos" 
set xlabel "Intentos"
set ylabel "Tiempo (s)"
set offset 0.01,2,0.01,0.01

plot "ruby.dat" using 1:2:(sprintf("(%d, %.3f)", $1, $2)) with labels offset char 1,1 notitle,\
     '' title 'Ruby' with linespoints,\
     "python.dat" using 1:2:(sprintf("(%d, %.3f)", $1, $2)) with labels offset char 1,1 notitle,\
     '' title 'Python' with linespoints,\
     "java.dat" using 1:2:(sprintf("(%d, %.3f)", $1, $2)) with labels offset char 1,1 notitle,\
     '' title 'Java' with linespoints,\
     "crystal.dat" using 1:2:(sprintf("(%d, %.3f)", $1, $2)) with labels offset char 1,1 notitle,\
     '' title 'Crystal' with linespoints
