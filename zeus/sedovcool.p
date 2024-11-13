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
set size square
set grid 
set format y "%T"
 set format x "%T"
u(x)=exp(c)*a*x**b
u1(x)=exp(c1)*a1*x**b1
u2(x)=exp(c2)*a2*x**b2
set xlabel "Log(t) (yr)"
set ylabel "Log(R_{shock}) (pc)"
set xrange [900: 5e5]
fit[0:3.e4][1:] u(x) "Sedovcool.dat" using 1:3 via a,b,c
fit[3.e4:1e5][1:] u1(x) "Sedovcool.dat" using 1:3 via a1,b1,c1
fit[1e5:*][1:] u2(x) "Sedovcool.dat" using 1:3 via a2,b2,c2
plot "Sedovcool.dat" using 1:2 t '' w l, "Sedovcool.dat" u 1:3 t '' w p pt 6, u2(x) lt rgb "red" 