# set terminal epslatex
set terminal epslatex standalone color colortext header \
   "\\usepackage{wasysym}\n\\usepackage{sfmath}\n\\renewcommand{\\familydefault}{\\sfdefault}\n"

set style line 1 linetype -1 linewidth 2 pt 1 pi 10
set style line 2 linetype 8 linewidth 5 lc rgb "#0091CE"
set style line 3 linetype 2 linewidth 5 lc rgb "#FF2712"
set style line 4 linetype 3 linewidth 5 lc rgb "#66B132"
set style line 5 linetype 5 linewidth 5 lc rgb "#8500AF"
set style line 6 linetype 9 linewidth 5 lc rgb "#FCBD00"

set xlabel "Axial direction [m]"
set ylabel "u [m.s\\textsuperscript{-1}]"

set key reverse Left bottom box opaque

# set yrange [-0.2:2.2]

set output 'condition_number_local_amp.tex'

plot 'condition_number/AMP0/K100/HB_N1_analytic_0000.dat' w l ls 1 t '$\kappa(E) = 1$', \
'condition_number/AMP0/K200/HB_N1_0000_0000.dat' w l ls 2 t '$\kappa(E) = 2$', \
'condition_number/AMP0/K400/HB_N1_0000_0000.dat' w l ls 3 t '$\kappa(E) = 4$', \
'condition_number/AMP0/K600/HB_N1_0000_0000.dat' w l ls 4 t '$\kappa(E) = 6$', \
'condition_number/AMP0/K800/HB_N1_0000_0000.dat' w l ls 5 t '$\kappa(E) = 8$', \
'condition_number/AMP0/K1000/HB_N1_0000_0000.dat' w l ls 6 t '$\kappa(E) = 10$'