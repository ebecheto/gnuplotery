set tics format "%.0s%c"
set ylabel "frequency [Hz]"
set y2label "period [s]"
set xlabel "Fast_{RO} code sorted index"
set xtics nomirror rotate by -270
set key bottom
set yrange [600E6:900E6]; set y2range [600E6:900E6]
if (!exist("code")) {code='14'}
pr "code==".code
filename='freqS_'.code.'_loopF.dat'
color="#FF000000"
sfile=sprintf("<sort -nk5 %s", filename)

#: yticlabel(gprintf('YOYO%.0s%c',$5))

plot sfile u 0:5:6:xtic(2) w yerrorlines t 'Fast_{RO}','' u 0:5 lw 0 lc rgb color  axis x1y2  notitle, "" u  0:3:4 t 'Slow_{RO} '.code.' code','' u ($0*5):3:(gprintf('%.0s%c',$3)) every 5 with labels rotate by 22 offset char 0,+2 notitle , "<sort -nk2 ALONE_SF.dat" u ($0+1):2:3 w yerrorlines t 'Fast_{RO} when Slow_{RO} OFF (Slow_{RO} code=31)'

# calculating function for the list of increment
linRg(start,end,increment)=system(sprintf("seq %g %g %g", start, increment, end))

do for [i in linRg(GPVAL_Y_MIN, GPVAL_Y_MAX, (GPVAL_Y_MAX-GPVAL_Y_MIN)/6)] { pr i; set y2tics add (gprintf("%.2s%c",1.0/i) i)}
set grid

old_term=GPVAL_TERM
set term pngcairo font "Sans,9"
outfile=filename[0:strstrt(filename, ".")-1].".png"
set output outfile; replot; pr "[".outfile."] saved"
set t old_term 0 font "Sans,9"; replot
