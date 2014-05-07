#@@@@@@@@@@@@@@@@@@@@@@@@@@@
# paper plot, initialization
#@@@@@@@@@@@@@@@@@@@@@@@@@@@
# global style definition
set style line 2 linetype -1 linewidth 4 lc rgb "gray70"
set style line 3  linetype -1 linewidth 2 pt 1
set style line 4 lc rgb "#0091CE" linetype -1 linewidth 2 pt 4
set style line 6 lc rgb "#FF2712" linetype -1 linewidth 2 pt 6


# global parameters
set terminal epslatex standalone color colortext header \
   "\\usepackage{wasysym}\n\\usepackage{sfmath}\n\\renewcommand{\\familydefault}{\\sfdefault}\n"
set xrange [0:1]

set size square

# legend definition
set key reverse Left left box spacing 1.3 opaque

#@@@@@@@@@@@@@@@@@@@@@@@@@@@
# figure
#@@@@@@@@@@@@@@@@@@@@@@@@@@@

# set labels
set xlabel 'Evenly spaced time instants'
set ylabel 'Non-evenly spaced time instants'

set output 'timelevels_distribution_f1.tex'
plot x w l ls 2 notitle,\
'timelevels_distribution_f1.dat' u 1:2 w linespoints ls 3 title 'EVE $\kappa(E) = 33.1$', \
'timelevels_distribution_f1.dat' u 1:3 w linespoints ls 4 title 'APFT $\kappa(E) = 3.8$', \
'timelevels_distribution_f1.dat' u 1:4 w linespoints ls 6 title 'OPT $\kappa(E) = 1.1$'

# set labels
set output 'timelevels_distribution_f2.tex'
plot x w l ls 2 notitle,\
'timelevels_distribution_f2.dat' u 1:2 w linespoints ls 3 title 'EVE $\kappa(E) = 33.1$', \
'timelevels_distribution_f2.dat' u 1:3 w linespoints ls 4 title 'APFT $\kappa(E) = 3.8$', \
'timelevels_distribution_f2.dat' u 1:4 w linespoints ls 6 title 'OPT $\kappa(E) = 1.1$'