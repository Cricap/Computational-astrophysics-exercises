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
u(x)=exp(c)*a*x**b
set xlabel "Log(t) (yr)"
set ylabel "Log(R_{shock}) (pc)"
set xrange [900: 5e5]
fit[0:3.e4][1:] u(x) "Sedovcool.dat" using 1:3 via a,b,c
fit[3.e4:1e5][1:] u(x) "Sedovcool.dat" using 1:3 via a,b,c
fit[1e5:*][1:] u(x) "Sedovcool.dat" using 1:3 via a,b,c
plot "Sedovcool.dat" using 1:2 t '' w l, "Sedovcool.dat" u 1:3 t '' w p pt 6, u(x) lt rgb "red" 