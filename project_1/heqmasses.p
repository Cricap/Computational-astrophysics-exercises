#Script file to print masses comparison graph

set autoscale # scale axes automatically
set size square
 unset log # remove any log-scaling
 unset label # remove any previous labels
 unset xtics
 unset ytics
 set logscale
 set xtic auto # set xtics automatically
 set ytic auto # set ytics automatically
 set format y "%T"
 set format x "%T"
 set title "NFW and numerical mass profiles comparison"
 set xlabel "Log r (kpc)"
 set ylabel "Log M (M_{⊙})" 
 plot "masse.dat" using 1:3 t 'Analytical profile' w lines, "masse.dat" u 1:2 t 'Numerical profile' w lines