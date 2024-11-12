set autoscale
set termopt enhanced
 unset log # remove any log-scaling
 unset label # remove any previous labels
 unset key
 unset xtics
 unset ytics
 unset title
 set size square
set grid 
 set xtic auto # set xtics automatically
 set ytic auto # set ytics automatically
set logscale
set format y "%T"
 set format x "%T"

 set xlabel "Log(t) (yr)"
 set ylabel "Log(E) (erg)"
set key
 plot "Energy.dat" using 1:2 t 'E_{tot}' w l, "Energy.dat" u 1:3 t 'E_{th}' w l, "Energy.dat" u 1:4 t 'E_{kin}' w l