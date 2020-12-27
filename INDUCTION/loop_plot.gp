#! /usr/bin/gnuplot
#https://stackoverflow.com/questions/24367146/gnuplot-linear-fit-within-for-loop
#https://stackoverflow.com/questions/58288993/convert-length-of-time-to-minute-format
# set xtics time format "%tM.%.2tS"
# set xtics time format "%M.%.2S"

# set xdata time
# set timefmt "%M.%2S"
#set format x '%M:%S'
set xrange ['00:00':'10:00']
#set xrange [0:10]
set title "température de chauffe d\'un litre d'eau en fonction du temps"
set ylabel "température [°C]"
set xlabel "temps [min]"

set key bottom right; set yrange [10:110];

set encoding iso_8859_1
fileList = "tefal_rouge.txt Lagostina.txt essentielB.txt tefal_noir.txt ikea.txt"
n=words(fileList)

i=1
# adjust time ie. 1min30second == 1.5 minutes
newFileList=""
do for [i=1:n] {
file=word(fileList, i)
S=strstrt(file,".")
datafile=file[1:S-1].".dat"
set table datafile
plot file u (int($1)+($1-int($1))/60.0*100):2
newFileList=newFileList." ".datafile
}
unset table

newFileList=fileList

array a[n]#<= starting from 1
array b[n]#<= starting from 1

fstr(N) = sprintf("f%d(x) = a%d*x + b%d", N, N, N)
fitstr(N) = sprintf("fit f%d(x) word(fileList, %d) via a%d,b%d",N,N,N,N,N)

do for [i=1:n] {
    eval(fstr(i));     eval(fitstr(i))
    eval(sprintf("a[%d]=a%d;  b[%d]=b%d",i,i,i,i))
}

# plot for [i=1:n] word(fileList,i) u 1:2 title sprintf("%s | y=%4.1f +[%4.1f]*x", word(fileList, i), a[i],b[i]), f%d(x) notitle
# quit
# construct the complete plotting string
plotstr = "plot "
do for [i=1:n] {
titre=sprintf("%s | y=%4.1f +[%4.1f]*x", word(fileList, i), b[i],a[i])
plotstr = plotstr . sprintf("f%d(x) lt %d notitle, ",i,i).\
sprintf(" '%s' u 1:2 lt %d t '%s' %s ",word(fileList,i), i,titre, (i == n) ? "" : ", ")
}

eval(plotstr)


set table 'datas.txt'
replot
unset table
