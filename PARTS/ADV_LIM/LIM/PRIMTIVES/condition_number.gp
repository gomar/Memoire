# set terminal epslatex
set terminal epslatex standalone color colortext header \
   "\\usepackage{wasysym}\n\\usepackage{sfmath}\n\\renewcommand{\\familydefault}{\\sfdefault}\n"

# set size 0.7, 0.7

set linetype 1 linetype 1 lw 3 pt 0 lc rgb "black"
set linetype 2 linetype 2 lw 3 pt 0 lc rgb "black"
set linetype 3 linetype 3 lw 3 pt 0 lc rgb "black"


set palette rgbformulae 30,31,32 negative
# set logscale x
# set logscale cb
set cbrange [0.2: 2.0]
set view map
set yrange [1.0: 1.1]
set pm3d corners2color c3

set xlabel 'amplitude'
set ylabel '$\kappa(E)$'
set clabel '$\mathcal{L}2$-error'

set output 'condition_number.tex'

splot 'condition_number/2d_error_map' u 1:2:3 w pm3d notitle
