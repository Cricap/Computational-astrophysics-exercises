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
set key
 set xlabel "Log(t) (yr)"
 set ylabel "Log(E) (erg)"
set yrange [0.001:*]
#set xrange [*:1e5]
 plot "Energycool.dat" using 1:2 t 'E_{tot}' w l, "Energycool.dat" u 1:3 t 'E_{th}' w l, "Energycool.dat" u 1:4 t 'E_{kin}' w l