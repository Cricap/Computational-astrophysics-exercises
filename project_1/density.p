set autoscale
 unset log # remove any log-scaling
 unset label # remove any previous labels
 unset xtics
 unset ytics
 set logscale
 set xtic auto # set xtics automatically
 set ytic auto # set ytics automatically
 set format y "%T"
 set format x "%T"
 set title "Density profiles"
 set xlabel "Log r (kpc)"
 set ylabel "Log {/Symbol r} (cgs)"
 set xrange [:1e4]
 set yrange[5.3e-29:]

 plot "density.dat" using 1:2 t 'no BCG' w l, "density2.dat" using 1:2 t 'iso BCG' w l, "density3.dat" using 1:2 t 'BCG and dT/dr' w l, "density.dat" using 1:3 t 'DM' w l dt 2