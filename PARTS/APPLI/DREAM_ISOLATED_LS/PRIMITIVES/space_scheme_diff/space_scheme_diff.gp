# set terminal epslatex
set terminal epslatex standalone color colortext header \
   "\\usepackage{wasysym}\n\\usepackage{sfmath}\n\\renewcommand{\\familydefault}{\\sfdefault}\n"

set style line 1 lc rgb "#268BD2" linetype -1 linewidth 2 pt 5
set style line 2 lc rgb "#002b36" linetype -1 linewidth 2 pt 4
set style line 3 lc rgb "#dc322f" linetype -1 linewidth 2 pt 3
set style line 4 lc rgb "#66B132" linetype -1 linewidth 2 pt 3
set style line 5 lc rgb "#FCBD00" linetype -1 linewidth 2 pt 3


set style fill solid 1.0
set output 'space_scheme_diff.tex'
set key reverse Left above

# Size of one box
bs = 0.15
# Plot mean with variance (std^2) as boxes with yerrorbar
plot 'space_scheme_diff.dat' i 0 u ($0):($7/1.4301):(bs) t 'Roe 1'  w boxes ls 1, \
     ''                      i 1 u ($0+bs):($7/1.4301):(bs) t 'Roe 2' w boxes ls 2, \
     ''                      i 2 u ($0+2*bs):($7/1.4301):(bs):xticlabels('$C_T / C_T^{Roe~2}$') t 'Roe 3' w boxes ls 3, \
     ''                      i 4 u ($0+3*bs):($7/1.4301):(bs) t 'JST $\kappa_4 = 0.032$' w boxes ls 4, \
     ''                      i 5 u ($0+4*bs):($7/1.4301):(bs) t 'JST $\kappa_4 = 0.064$' w boxes ls 5, \
     ''                      i 0 u (1+$0):($8/2.8554):(bs) notitle  w boxes ls 1, \
     ''                      i 1 u (1+$0+bs):($8/2.8554):(bs) notitle w boxes ls 2, \
     ''                      i 2 u (1+$0+2*bs):($8/2.8554):(bs):xticlabels('$C_P/ C_P^{Roe~2}$') notitle w boxes ls 3, \
     ''                      i 4 u (1+$0+3*bs):($8/2.8554):(bs) notitle w boxes ls 4, \
     ''                      i 5 u (1+$0+4*bs):($8/2.8554):(bs) notitle w boxes ls 5, \
     ''                      i 0 u (2+$0):($9/0.5659):(bs) notitle  w boxes ls 1, \
     ''                      i 1 u (2+$0+bs):($9/0.5659):(bs) notitle w boxes ls 2, \
     ''                      i 2 u (2+$0+2*bs):($9/0.5659):(bs):xticlabels('$\eta/ \eta^{Roe~2}$') notitle w boxes ls 3, \
     ''                      i 4 u (2+$0+3*bs):($9/0.5659):(bs) notitle w boxes ls 4, \
     ''                      i 5 u (2+$0+4*bs):($9/0.5659):(bs) notitle w boxes ls 5, 1 w l ls 1 lc rgb "black" title ""