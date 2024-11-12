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
set grid
set size square
set key top left font ",5"
 set xlabel "Log(r) in pc"
 set ylabel "Density"
 plot "resultssncool01.dat" using 2:3 t 't=10^{4}' w l, "resultssncool02.dat" using 2:3 t 't=2*10^{4}' w l, "resultssncool03.dat" using 2:3 t 't=4*10^{4}' w l, \
 "resultssncool04.dat" using 2:3 t 't=6*10^{4}' w l, "resultssncool05.dat" using 2:3 t 't=8*10^{4}' w l, "resultssncool06.dat" using 2:3 t 't=10^{5}' w l
 set key bottom left font ",5"
 set xlabel "Log(r) in pc"
 set ylabel "Pressure"
 plot "resultssncool01.dat" using 2:6 t 't=10^{4}' w l, "resultssncool02.dat" using 2:6 t 't=2*10^{4}' w l, "resultssncool03.dat" using 2:6 t 't=4*10^{4}' w l,\
 "resultssncool04.dat" using 2:6 t 't=6*10^{4}' w l, "resultssncool05.dat" using 2:6 t 't=8*10^{4}' w l, "resultssncool06.dat" using 2:6 t 't=10^{5}' w l
set key top left font ",5"
 unset logscale
 set logscale x
 set format y "%g"
 set xlabel "Log(r) in pc"
 set ylabel "Velocity (cm/s)"
 plot "resultssncool01.dat" using 2:4 t 't=10^{4}' w l, "resultssncool02.dat" using 2:4 t 't=2*10^{4}' w l, "resultssncool03.dat" using 2:4 t 't=4*10^{4}' w l, \
 "resultssncool04.dat" using 2:4 t 't=6*10^{4}' w l, "resultssncool05.dat" using 2:4 t 't=8*10^{4}' w l, "resultssncool06.dat" using 2:4 t 't=10^{5}' w l
 set key bottom left font ",5"
 set logscale y
 set format y "%T"
 set xlabel "Log(r) in pc"
 set ylabel "log(T)"
 plot "resultssncool01.dat" using 2:7 t 't=10^{4}' w l, "resultssncool02.dat" using 2:7 t 't=2*10^{4}' w l, "resultssncool03.dat" using 2:7 t 't=4*10^{4}' w l, \
 "resultssncool04.dat" using 2:7 t 't=6*10^{4}' w l, "resultssncool05.dat" using 2:7 t 't=8*10^{4}' w l, "resultssncool06.dat" using 2:7 t 't=10^{5}' w l