set macro

# ===========
# = TO FILL =
# ===========
case = 'CONVECTION_SIN_1_N1'
nharm = '1'
inj = 'SIN_1'
sim = 'TSM'


# global parameters
set style line 1 lc rgb "#268bd2" linetype -1 linewidth 2
set style line 2 linetype -1 linewidth 2 pt 6 pi 100
set style line 3 lc rgb "#d33682" linetype -1 linewidth 1
set style line 4 lc rgb "#6c71c4" linetype -1 linewidth 1
set style line 5 lc rgb "#dc322f" linetype -1 linewidth 1
set style line 6 lc rgb "#2aa198" linetype -1 linewidth 1
set style line 7 lc rgb "#002b36" linetype -1 linewidth 1
set terminal epslatex standalone
set key reverse Left right box spacing 1.5
set output 'CONVECTION_'.inj.'_'.sim.'_N'.nharm.'.tex'

set yrange [-1:1]
set ytics 1

# figure n 1
unset key
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
set label '$t = 2 / 3T$' center at graph 1.03, graph 0.5 rotate by 90
set xlabel "Axial direction [m]"
set origin DX, DY
plot '../../RESULTS/'.inj.'/TSM_N'.nharm.'_0000_0002.dat' w lp ls 2,\
'../../RESULTS/'.inj.'/TSM_N'.nharm.'_analytic_0002.dat' w l ls 1
unset label
# t = 1 / 3  Lt
set label '$t = 1 / 3T$' center at graph 1.03, graph 0.5 rotate by 90
set xlabel ""
set format x ""
set origin DX,DY+SY*1
plot '../../RESULTS/'.inj.'/TSM_N'.nharm.'_0000_0001.dat' w lp ls 2,\
'../../RESULTS/'.inj.'/TSM_N'.nharm.'_analytic_0001.dat' w l ls 1
unset label
# t = 2 / 3  Lt
set label '$t = 0$' center at graph 1.03, graph 0.5 rotate by 90
set origin DX,DY+SY*2
plot '../../RESULTS/'.inj.'/TSM_N'.nharm.'_0000_0000.dat' w lp ls 2,\
'../../RESULTS/'.inj.'/TSM_N'.nharm.'_analytic_0000.dat' w l ls 1
unset multiplot
