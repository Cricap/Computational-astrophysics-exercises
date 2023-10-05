#Script file for energy values for circular orbits

set autoscale # scale axes automatically
 unset log # remove any log-scaling
 unset label # remove any previous labels
 set xtic auto # set xtics automatically
 set ytic auto # set ytics automatically
 set title "Energy in circular orbits"
 set xlabel "Time (yr)"
 set ylabel "Energy (cgs)"
 set size square
 plot "orbitEC.dat" u 1:6 t 'Ekin' w linespoints , "orbitEC.dat" u 1:7 t 'Epot' w points , "orbitEC.dat" u 1:8 t 'Etot' 