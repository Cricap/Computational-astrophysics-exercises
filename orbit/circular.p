#Script file to print circular orbits

set autoscale # scale axes automatically
 unset log # remove any log-scaling
 unset label # remove any previous labels
 set xtic auto # set xtics automatically
 set ytic auto # set ytics automatically
 set title "Circular orbits"
 set xlabel "x (A.U.)"
 set ylabel "y (A.U.)" 
  set size square
  plot "orbit.dat" using 2:3 t ' '