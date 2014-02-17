set macro

# ===========
# = TO FILL =
# ===========
case = 'TSM'
result_path = 'multifreq/'

# global parameters
set style line 1 linetype -1 linewidth 2 pt 6
set style line 2 lc rgb "#268bd2" linetype 2  linewidth 4 pt 3 ps 1.5

set terminal epslatex standalone color colortext header \
   		"\\usepackage{wasysym}\n\\usepackage{sfmath}\n\\renewcommand{\\familydefault}{\\sfdefault}\n"
# set key reverse Left right opaque box
set output 'convection_multifreq_error.tex'

set xlabel '\# harmonics'
set ylabel '$\frac{\| u - u_{analytic} \|_2}{\| u_{analytic} \|_2}$'
set format y '$10^{%L}$'

set logscale y

plot result_path.'tsm_norm.dat' w lp ls 1 notitle