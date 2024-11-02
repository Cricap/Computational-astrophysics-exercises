set autoscale
set termopt enhanced
set multiplot layout 2,3 rowsfirst title "Strong shock tube with cartesian coordinates"
 unset log # remove any log-scaling
 unset label # remove any previous labels
 unset key
 unset xtics
 unset ytics
 unset title
 set xtic auto # set xtics automatically
 set ytic auto # set ytics automatically
set grid
set size square

 set xlabel "X_{1}"
 set ylabel "Density"
 set xrange [0:1]
 plot "results.dat" using 2:3 t '' w p ls 6
 set xlabel "X_{1}"
 
 set ylabel "Pressure"
 set xrange [0:1]
 plot "results.dat" using 2:6 t '' w p ls 6
 set yrange [0:0.2]
 set xlabel "X_{1}"
 set ylabel "Velocity"
 set xrange [0:1]
 plot "results.dat" using 2:4 t '' w p ls 6
 set autoscale
 set xlabel "X_{1}"
 set lmargin 40
 set ylabel "Specific energy"
 set xrange [0:1]
 plot "results.dat" using 2:5 t '' w p ls 6
set yrange [0:4]

 set xlabel "X_{1}"
 set ylabel "Momentum"
 set xrange [0:1]
 plot "results.dat" using 2:7 t '' w p ls 6

 unset multiplot