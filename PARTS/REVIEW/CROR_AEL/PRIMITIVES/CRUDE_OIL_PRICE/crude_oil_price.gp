# set labels
set xlabel 'year'
set ylabel 'US dollars per barrel'

set key reverse Left

# global parameters for the plot
set style line 1 lc rgb "#268BD2" linetype -1 linewidth 2 pt 5
set style line 2 lc rgb "#dc322f" linetype -1 linewidth 2 pt 4
set style line 3 lc rgb "#002b36" linetype -1 linewidth 2 pt 3
set style line 4 linetype -1 linewidth 2 pt 4

# adding custom header to latex for permille symbol
set terminal epslatex standalone header \
   "\\usepackage{wasysym}\n\\usepackage{sfmath}\n\\renewcommand{\\familydefault}{\\sfdefault}\n"

set output 'crude_oil_price.tex'
plot 'crude_oil_price.dat' u 1:2 w l ls 1 title '\$ money of the day',\
'' u 1:3 w l ls 2 title '\$ 2012',\
