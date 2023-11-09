set autoscale
set size square
unset key
 unset log # remove any log-scaling
 unset label # remove any previous labels
 unset xtics
 unset ytics
 set logscale
 set xtic auto # set xtics automatically
 set ytic auto # set ytics automatically
 set format y "%T"
 set format x "%T"
 set title "Comparison of density profiles with Rebusco et al."
 set xlabel "Log r (kpc)"
 set ylabel "Log {/Symbol r} (cgs)"
 set xrange [:4500]
 set yrange[5.3e-29:2.2e-25]
 set key at 2840, 6.45e-26
 plot "density3.dat" using 1:2 t 'BCG and dT/dr' w l, "density3.dat" using 1:5 t 'Rebusco' w l