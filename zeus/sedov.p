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
 set ylabel "Log(R_{shock}) (pc)"
set xrange [900: 5e5]
 plot "Sedov.dat" using 1:2 t '' w l, "Sedov.dat" u 1:3 t '' w p