set macro

# ===========
# = TO FILL =
# ===========
case = 'multifreq_tsm'
result_path = 'multifreq/'

# global parameters
set style line 1 linetype -1 linewidth 4 pt 7 pi 100 ps 1.5
set style line 2 lc rgb "#0091CE" linetype -1 linewidth 2 pt 5 ps 2
set style line 3 lc rgb "#FF2712" linetype -1 linewidth 2 pt 12 ps 2.5
set style line 4 lc rgb "#8500AF" linetype -1 linewidth 2 pt 9 ps 2
set style line 5 lc rgb "#66B132" linetype -1 linewidth 2 pt 10 ps 2.5
set style line 6 lc rgb "#FCBD00" linetype -1 linewidth 2 pt 2 ps 2

set terminal epslatex standalone color colortext header \
		"\\usepackage{wasysym}\n\\usepackage{sfmath}\n\\renewcommand{\\familydefault}{\\sfdefault}\n"
set key reverse Left right box spacing 1.5
set xrange [0:1.0]
set xtics ("0" 0, "$L_x / 4$" 0.25, "$L_x / 2$" 0.5, "$3 L_x / 4$" 0.75, "$L_x$" 1.0)

# SIN
set yrange [-1:3]
set ytics 1

set output 'convection_mutlifreq.tex'

# figure n 1
NX=1; NY=3
DX=0.6; DY=0.; SX=0.85; SY=0.4
set bmargin DX
set tmargin DX
set lmargin DY
set rmargin DY
## set the margin of each side of a plot as small as possible
## to connect each plot without space
set size SX*NX+DX*1.5, SY*NY+DY*1.8
set multiplot
##—— First Figure–bottom
set size SX,SY
# t = 0.
set label '$t = 2T / 3$' center at graph 1.03, graph 0.5 rotate by 90
unset key
set xlabel "Axial direction [m]"
set origin DX, DY
plot result_path.'TSM_N1_analytic_0002.dat' w lp ls 1, \
result_path.'TSM_N20_0000_0002.dat' w l ls 4, \
result_path.'TSM_N21_0000_0002.dat' w l ls 3, \
result_path.'TSM_N22_0000_0002.dat' w l ls 2

unset label
unset key
set format y ""
set xtics ("" 0, "" 0.25, "" 0.5, "" 0.75, "" 1.0)
# set xtics ("" 0,  "" 0.5, "" 1)
# t = 1 / 3  Lt
set label '$t = T / 3$' center at graph 1.03, graph 0.5 rotate by 90
set xlabel ""
set format x ""
set origin DX,DY+SY*1
plot result_path.'TSM_N1_analytic_0001.dat' w lp ls 1, \
result_path.'TSM_N20_0000_0001.dat' w l ls 4, \
result_path.'TSM_N21_0000_0001.dat' w l ls 3, \
result_path.'TSM_N22_0000_0001.dat' w l ls 2
unset label
# t = 2 / 3  Lt
set label '$t = 0$' center at graph 1.03, graph 0.5 rotate by 90
set origin DX,DY+SY*2
set key reverse Left box spacing 1.5 center at graph 0.5, graph 1.23 maxrows 2
plot result_path.'TSM_N1_analytic_0000.dat' w lp ls 1 t 'Analytic', \
result_path.'TSM_N20_0000_0000.dat' w l ls 4 t '$N=20$', \
result_path.'TSM_N21_0000_0000.dat' w l ls 3 t '$N=21$', \
result_path.'TSM_N22_0000_0000.dat' w l ls 2 t '$N=22$'

unset multiplot
