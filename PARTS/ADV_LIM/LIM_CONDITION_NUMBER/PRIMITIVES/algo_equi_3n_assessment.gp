# set terminal epslatex
set terminal epslatex standalone color colortext header \
   "\\usepackage{wasysym}\n\\usepackage{sfmath}\n\\renewcommand{\\familydefault}{\\sfdefault}\n"

# set size 0.7, 0.7

set linetype 1 linetype 1 lw 3 pt 0 lc rgb "black"
set linetype 2 linetype 2 lw 3 pt 0 lc rgb "black"
set linetype 3 linetype 3 lw 3 pt 0 lc rgb "black"


set palette rgbformulae 30,31,32 negative
set view map
set size square

# set logscale cb
set cbrange [1:10]

set datafile missing "nan"

set xlabel '$f_1$ ($\times 10^3$)'
set ylabel '$f_2$ ($\times 10^3$)'
set cblabel '$\kappa(E)$'

set format x "%1.0s"
set format y "%1.0s"

set output 'algo_equi_3n_assessment.tex'

splot 'algo_equi_3n_assessment.dat' u 1:2:($3) w pm3d notitle
