
 set autoscale
 set termopt enhanced
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
 set title "Temperature profiles"
 set xlabel "Log r (kpc)"
 set ylabel "Log T (K)"
 set yrange [3.2e7:1.2e8]
 set key at 5, 8e7
 set size square
 plot "temperature.dat" using 1:2 t 'T(r)' w l, "temperature.dat" using 1:4 t 'T_{mg}' w l, "temperature.dat" using 1:5 t 'T_{Rebusco et al.}' w l
