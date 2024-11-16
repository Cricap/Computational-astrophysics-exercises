set autoscale
set termopt enhanced
set multiplot layout 1,2 rowsfirst
 unset log # remove any log-scaling
 unset label # remove any previous labels
 unset key
 unset xtics
 unset ytics
 unset title
 set xtic auto # set xtics automatically
 set ytic auto # set ytics automatically
 set size square
set grid 
set format y "%T"
 set format x "%T"
set logscale 
 set xlabel "Log(t) (yr)"
 set ylabel "Log(L_{x}) (erg/s)"
f(x)=B*x**a
B=1e29
a=2
f1(x)=E*x**d
E=1e29
d=1.95
set xrange[1e3:1e5]
fit[6e3:2.5e4][1e34:]f(x) 'Luminosity.dat' using 1:2 via B,a
fit[6e3:2.5e4][1e34:]f1(x) 'Luminositycool.dat' using 1:2 via E,d
plot "Luminosity.dat" using 1:2 t 'L_{X}' w l, "Luminositycool.dat" using 1:2 t 'L_{X} with cooling' w l, f(x) lt rgb "red", f1(x) lt rgb "skyblue"
set xrange[2e3:5e5]
f2(x)=C*x**o
C=1e52

f3(x)=G*x**u
G=1e58
u=-4.5
fit[3.2e4:1e5]f2(x) 'Luminosity.dat' using 1:2 via C,o
fit[3.2e4:1e5]f3(x) 'Luminositycool.dat' using 1:2 via G,u
plot "Luminosity.dat" using 1:2 t 'L_{X}' w l, "Luminositycool.dat" using 1:2 t 'L_{X} with cooling' w l, f2(x) lt rgb "red", f3(x) lt rgb "skyblue"