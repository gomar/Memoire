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

set key reverse Left bottom box

set yrange [-0.2:2.2]

set output 'condition_number_local_amp.tex'

plot 'condition_number/AMP0/K100/HB_N1_analytic_0000.dat' w l ls 1 t 'analytic', \
'condition_number/AMP0/K102/HB_N1_0000_0000.dat' w l ls 2 t '$\kappa(E) = 1.02$', \
'condition_number/AMP0/K104/HB_N1_0000_0000.dat' w l ls 3 t '$\kappa(E) = 1.04$', \
'condition_number/AMP0/K106/HB_N1_0000_0000.dat' w l ls 4 t '$\kappa(E) = 1.06$', \
'condition_number/AMP0/K108/HB_N1_0000_0000.dat' w l ls 5 t '$\kappa(E) = 1.08$', \
'condition_number/AMP0/K110/HB_N1_0000_0000.dat' w l ls 6 t '$\kappa(E) = 1.10$'