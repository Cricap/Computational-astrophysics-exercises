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
 set title "Comparison of analytical and numerical density profiles in the isothermal without BCG case"
 set xlabel "Log r (kpc)"
 set ylabel "Log {/Symbol r} (g/cm^{3})"
 set key at 2840, 6.45e-26
 plot "density.dat" using 1:2 t 'Numerical' w l, "density.dat" using 1:5 t 'Analytical' w l