set tics format "%.1s%c"
set xtics nomirror rotate by -270
set ylabel "Slow RO Freq"
set xlabel 'sorted code'
filename="Slow_alone.log"
#plot "<sort -nk2 $filename" u 0:2:3:xtic(1) w yerrorlines
plot sprintf("<sort -nk2 %s", filename) u 0:2:3:xtic(1) w yerrorlines,'' u ($0*5):2:(gprintf('%.0s%c',$2)) every 5 with labels rotate by -22 offset char 0,-2 notitle 

set term pngcairo font "Sans,9"
outfile=filename[0:strstrt(filename, ".")-1].".png"
set output outfile; replot; pr "[".outfile."] printed"
set t qt 0 font "Sans,9"; replot
