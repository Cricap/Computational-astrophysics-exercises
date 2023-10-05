#Script file to print circular orbits

set autoscale # scale axes automatically
 unset log # remove any log-scaling
 unset label # remove any previous labels
 set xtic auto # set xtics automatically
 set ytic auto # set ytics automatically
 set title "Elliptical orbits"
 set xlabel "x (A.U.)"
 set ylabel "y (A.U.)" 
 set yr [-1.5:1.5]
 set xr [-1.5:1.5]
  set size square
  plot "orbitECell.dat" using 2:3 t ' '