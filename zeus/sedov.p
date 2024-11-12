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
f(x)=B*x**a
B=20
f1(x)=E*x**d
E=20
set xlabel "Log(t) (yr)"
set ylabel "Log(R_{shock}) (pc)"
set xrange [900: 5e5]
fit[900:3.e4][1:]f(x) 'Sedov.dat' using 1:3 via B,a
fit[2e5:*][1:] f1(x) 'Sedov.dat' using 1:3 via E,d

 plot "Sedov.dat" using 1:2 t '' w l, "Sedov.dat" u 1:3 t '' w p pt 6, f(x) lt rgb "red", f1(x) lt rgb "red"