# set terminal epslatex
# set size 0.7, 0.7

set linetype 1 linetype 1 lw 3 pt 0 lc rgb "black"
set linetype 2 linetype 2 lw 3 pt 0 lc rgb "black"
set linetype 3 linetype 3 lw 3 pt 0 lc rgb "black"

set terminal epslatex standalone color colortext header \
   "\\usepackage{wasysym}\n\\usepackage{sfmath}\n\\renewcommand{\\familydefault}{\\sfdefault}\n"
set palette rgbformulae 30,31,32 negative

set view map
set size square

set format cb '$10^{%L}$'

set datafile missing "nan"

set logscale cb

set format x "%1.0s"
set format y "%1.0s"

set xlabel '$f_1$ ($\times 10^3$)'
set ylabel '$f_2$ ($\times 10^3$)'
set cblabel '$\Im(D_t) / \Re (D_t)$'

set cbrange [1e-16:1]

set output 'algo_equi_assessment.tex'
splot 'algo_equi_assessment.dat' u 1:2:($3) w pm3d notitle

set output 'algo_opt_assessment.tex'
splot 'algo_opt_assessment.dat' u 1:2:($3) w pm3d notitle

set cbrange [1e-16:1e-12]

set output 'algo_opt_assessment_zoom.tex'
splot 'algo_opt_assessment.dat' u 1:2:($3) w pm3d notitle
