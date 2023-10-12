#Script file to print masses comparison graph

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
 set title "Dark matter mass comparison"
 set xlabel "Log r (kpc)"
 set ylabel "Log M (M*)" 
 plot "masse.dat" using 1:2 t '', "masse.dat" u 1:3 t ''