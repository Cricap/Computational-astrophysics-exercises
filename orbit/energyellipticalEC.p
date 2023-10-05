#Script file for energy values for circular orbits

set autoscale # scale axes automatically
 unset log # remove any log-scaling
 unset label # remove any previous labels
 set xtic auto # set xtics automatically
 set ytic auto # set ytics automatically
 set title "Energy in Elliptical orbits"
 set xlabel "Time (yr)"
 set ylabel "Energy (cgs)"
 set size square
 plot "orbitECell.dat" u 1:6 t 'Ekin' w linespoints , "orbitECell.dat" u 1:7 t 'Epot' w points , "orbitECell.dat" u 1:8 t 'Etot' 