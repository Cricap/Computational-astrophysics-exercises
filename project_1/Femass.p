set autoscale # scale axes automatically

 unset log # remove any log-scaling
 unset label # remove any previous labels
 unset xtics
 unset ytics
 set logscale
 set xtic auto # set xtics automatically
 set ytic auto # set ytics automatically
 set format y "%T"
 set format x "%T"
 set title "Numerical and theorectical M_{Fe} profiles comparison"
 set xlabel "Log r (kpc)"
 set ylabel "Log M (M_{⊙})" 
 set yrange [1e5: *]
 set xrange [0.56:*]
 plot "diff.dat" using 3:5 t 'Analytical profile' w lines, "diff.dat" u 3:4 t 'Numerical profile' w lines