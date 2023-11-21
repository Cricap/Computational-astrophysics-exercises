set autoscale
set termopt enhanced
set multiplot layout 2,2 rowsfirst title "Radial profiles of variables"
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

 set xlabel "Log(r) in pc"
 set ylabel "Density"
 plot "resultssn07.dat" using 2:3 t '' w l, "resultssn08.dat" using 2:3 t '' w l, "resultssn09.dat" using 2:3 t '' w l, "resultssn10.dat" using 2:3 t '' w l

 set xlabel "Log(r) in pc"
 set ylabel "Pressure"
 plot "resultssn07.dat" using 2:6 t '' w l, "resultssn08.dat" using 2:6 t '' w l, "resultssn09.dat" using 2:6 t '' w l, "resultssn10.dat" using 2:6 t '' w l
 
 unset logscale
 set logscale x
 set xlabel "Log(r) in pc"
 set ylabel "Velocity"
 plot "resultssn07.dat" using 2:4 t '' w l, "resultssn08.dat" using 2:4 t '' w l, "resultssn09.dat" using 2:4 t '' w l, "resultssn10.dat" using 2:4 t '' w l
 
 set logscale y
 set xlabel "Log(r) in pc"
 set ylabel "log(T)"
 plot "resultssn07.dat" using 2:7 t '' w l, "resultssn08.dat" using 2:7 t '' w l, "resultssn09.dat" using 2:7 t '' w l, "resultssn10.dat" using 2:7 t '' w l