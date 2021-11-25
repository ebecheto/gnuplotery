set tics format "%.1s%c"
set xtics nomirror rotate by -270
set ylabel "Freqency [Hz]"
set key bottom
set xlabel 'sorted code'
# set format x "==%.3g" # marche pas ?
filename="ALONE_SF.dat"
plot "<sort -nk2 ".filename u 0:2:3:xtic(system(sprintf("python -c \"print(bin(%g)[2:].rjust(5,\\\"0\\\"))\"", $1)).sprintf(" = %02g", $1)) w yerrorlines t "Fast freQ Slow OFF",'' u 0:5:6 w yerrorlines t "Slow freQ Fast OFF"

#plot filename u 4:5:6
# binStr=system(sprintf("python -c \"print(bin(%g)[2:].rjust(8,\\\"0\\\"))\"", 9))

set term pngcairo font "Sans,9"
outfile=filename[0:strstrt(filename, ".")-1].".png"
set output outfile; replot; pr "[".outfile."] saved"
#system(sprintf("convert -resize 60%% %s %s ", outfile, outfile))
system(sprintf("convert -units PixelsPerInch %s -density 200 %s ", outfile, outfile))#<= avoid winword rescaling
set t qt 0 font "Sans,9"; replot
