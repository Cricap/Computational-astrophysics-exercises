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
 plot "resultssncool07.dat" using 2:3 t '2' w l, "resultssncool08.dat" using 2:3 t '3' w l, "resultssncool09.dat" using 2:3 t '4' w l, "resultssncool10.dat" using 2:3 t '5' w l

 set xlabel "Log(r) in pc"
 set ylabel "Pressure"
 plot "resultssncool07.dat" using 2:6 t '' w l, "resultssncool08.dat" using 2:6 t '' w l, "resultssncool09.dat" using 2:6 t '' w l, "resultssncool10.dat" using 2:6 t '' w l
 set format y "%g"
 unset logscale
 set logscale x
 set xlabel "Log(r) in pc"
 set ylabel "Velocity"
 plot "resultssncool07.dat" using 2:4 t '' w l, "resultssncool08.dat" using 2:4 t '' w l, "resultssncool09.dat" using 2:4 t '' w l, "resultssncool10.dat" using 2:4 t '' w l
 set format y "%T"
 set logscale y
 set xlabel "Log(r) in pc"
 set ylabel "log(T)"
 set key
 plot "resultssncool07.dat" using 2:7 t '2' w l, "resultssncool08.dat" using 2:7 t '3' w l, "resultssncool09.dat" using 2:7 t '4' w l, "resultssncool10.dat" using 2:7 t '5' w l