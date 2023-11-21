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
 plot "resultssncool01.dat" using 2:3 t '' w l, "resultssncool02.dat" using 2:3 t '' w l, "resultssncool03.dat" using 2:3 t '' w l, "resultssncool04.dat" using 2:3 t '' w l, \
 "resultssncool05.dat" using 2:3 t '' w l, "resultssncool06.dat" using 2:3 t '' w l
 
 set xlabel "Log(r) in pc"
 set ylabel "Pressure"
 plot "resultssncool01.dat" using 2:6 t '' w l, "resultssncool02.dat" using 2:6 t '' w l, "resultssncool03.dat" using 2:6 t '' w l, "resultssncool04.dat" using 2:6 t '' w l, \
 "resultssncool05.dat" using 2:6 t '' w l, "resultssncool06.dat" using 2:6 t '' w l
 
 unset logscale
 set logscale x
 set xlabel "Log(r) in pc"
 set ylabel "Velocity"
 plot "resultssncool01.dat" using 2:4 t '' w l, "resultssncool02.dat" using 2:4 t '' w l, "resultssncool03.dat" using 2:4 t '' w l, "resultssncool04.dat" using 2:4 t '' w l, \
 "resultssncool05.dat" using 2:4 t '' w l, "resultssncool06.dat" using 2:4 t '' w l
 
 set logscale y
 set xlabel "Log(r) in pc"
 set ylabel "log(T)"
 plot "resultssncool01.dat" using 2:7 t '' w l, "resultssncool02.dat" using 2:7 t '' w l, "resultssncool03.dat" using 2:7 t '' w l, "resultssncool04.dat" using 2:7 t '' w l, \
 "resultssncool05.dat" using 2:7 t '' w l, "resultssncool06.dat" using 2:7 t '' w l