
labs="i modf int round floor ceiling"
set font "Veranda, 10"
set yrange [-1:1]

set tmargin 0;set bmargin 0;set lmargin 1;set rmargin 1;unset xtics
set multiplot layout 5, 1 margins 0.1,0.95,.1,.99 spacing 0,0

last=6
do for [i=2:last:1] {
if (i==last) {set xtics};
plot "my_modf.dat" u 1:i w lp title word(labs, i)
}
unset multiplot
