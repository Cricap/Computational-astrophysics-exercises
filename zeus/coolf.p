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
set grid
set size square
 set xlabel "Log(T) (K)"
 set ylabel "Log({/Symbol L}) (erg cm^{3} s^{-1})"
set xrange [10000:1e9]

 plot "Coolingf.dat" using 2:1 t '' w l