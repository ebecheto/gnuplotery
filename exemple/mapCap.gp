# https://stackoverflow.com/questions/37449004/making-x-y-tics-dynamically-in-gnuplot/37453347#37453347
# http://www.phyast.pitt.edu/~zov1/gnuplot/html/broken.html

#set size ratio 0.5
#old_term=GPVAL_TERM

file="mapCap.dat"
set xrange [0:63]; set yrange [0:2]
set terminal GPVAL_TERM size  1200,400 
set ytics ("bas" 0, "milieu" 1, "haut" 2)
set view map
set pm3d at b map
set dgrid3d 200,200,2
splot file u 1:2:3, '' u 1:2:3:3 w labels  rotate by -22 offset char 0,+1 notitle 

old_term=GPVAL_TERM
set term pngcairo font "Sans,9" size 1200,400 
outfile=file[0:strstrt(file, ".")-1].".png"
set output outfile; replot; pr "[".outfile."] saved"
set t old_term 0 font "Sans,9"; replot