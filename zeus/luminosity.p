set autoscale
set termopt enhanced
 unset log # remove any log-scaling
 unset label # remove any previous labels
 unset key
 unset xtics
 unset ytics
 unset title
 set xtics 50000 # set xtics automatically
 set ytic auto # set ytics automatically
#set logscale
set size square
set grid 
set format y "%T"
 set format x "%1.1s"
set logscale y
 set xlabel "t⋅10^{3} (yr)"
 set ylabel "Log(L_{x}) (erg/s)"
#set xtics add ("1" 0)
set xrange [0:5e5]
set key
 plot "Luminosity.dat" using 1:2 t 'L_{X}' w l, "Luminositycool.dat" using 1:2 t 'L_{X} with cooling' w l