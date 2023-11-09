set autoscale
set termopt enhanced

 unset log # remove any log-scaling
 unset label # remove any previous labels
 unset key
 unset xtics
 unset ytics
 set logscale x
 set xtic auto # set xtics automatically
 set ytic auto # set ytics automatically
 #set format y "%T"
 set format x "%T"
 set title "Z_{Fe} profiles with diffusion and source"
 set xlabel "Log r (kpc)"
 set ylabel "Z_{Fe} (Z sol)"
 datafile = 'time_start.dat'
 firstrow = system('head -1 '.datafile)
 time= word(firstrow, 1)
 set label at 400, 2.3 gprintf("t= %g Gyrs", time)
  datafile1='kappa.dat'
 firstrow1 = system('head -1 '.datafile1)
 kappa= word(firstrow1, 1)
 set label at 400, 2.2 gprintf("K= %g cgs", kappa)
 datafile2='snu.dat'
 firstrow2 = system('head -1 '.datafile2)
 snu= word(firstrow2, 1)
 set label at 400, 2.1 gprintf("SnU= %g ", snu)
 set key at 1000, 2.0
 set yrange [0: 2.5]
 set xrange [1:*]
 plot "diff.dat" using 1:2 t 'Z_{Fe}' w l, "zfe_initial.dat" using 1:4 t 'Z_{Fe,obs}-Z_{Fe,out}' w l, "zfe_initial.dat" using 1:3 t 'Z_{Fe,obs}' w l