# set terminal epslatex
set terminal epslatex standalone color colortext header \
   "\\usepackage{wasysym}\n\\usepackage{sfmath}\n\\renewcommand{\\familydefault}{\\sfdefault}\n"

# set size 0.7, 0.7

set linetype 1 linetype 1 lw 3 pt 0 lc rgb "black"
set linetype 2 linetype 2 lw 3 pt 0 lc rgb "black"
set linetype 3 linetype 3 lw 3 pt 0 lc rgb "black"


set palette defined (0 '#0000ff', 0.25 '#00ffff', 0.5 '#00ff00', 0.75 '#ffff00', 1.0 '#ff0000', 1.25 '#ffffff')
# set logscale cb
# set logscale x
set cbrange [0.0001: 1.5]
set view map
# set pm3d corners2color c3

set xlabel 'amplitude $[-]$'
set ylabel '$\kappa(E)$'
set clabel '$\mathcal{L}2$-error'

set output 'condition_number.tex'

splot 'condition_number/2d_error_map' u 1:2:3 w pm3d notitle
