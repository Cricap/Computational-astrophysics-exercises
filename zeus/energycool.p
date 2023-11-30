set autoscale
set termopt enhanced
 unset log # remove any log-scaling
 unset label # remove any previous labels
 unset key
 unset xtics
 unset ytics
 unset title
 set xtic auto # set xtics automatically
 set ytic auto # set ytics automatically
set logscale
set format y "%T"
 set format x "%T"

 set xlabel "Log(t) (yr)"
 set ylabel "Log(E) (erg)"
set yrange [0.1:*]
#set xrange [*:1e5]
 plot "Energycool.dat" using 1:2 t '' w l, "Energycool.dat" u 1:3 t '' w l, "Energycool.dat" u 1:4 t '' w l