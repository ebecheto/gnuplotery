# Plan de Charge
#set term x11 enhanced size 1600,600 rounded font "Calibri,8"
#set term pdfcairo enhanced size 21cm,9cm rounded font "Calibri,8"
# set term svg enhanced size 1600,600 rounded font "LM Sans 8,8"
#gnuplot -e "file='new_plan.txt'; type2numFile='type2num.gp'" boxxy.gp -
#file='< sort -k2,2'.file
if (!exists("file")) file="new_plan.txt"
#set output "Planning_ETE_2016.pdf" 
#load "parula.pal"
#load "dark2.pal"
# set palette color
# set palette model RGB
set palette defined ( 0 "green", 1 "blue", 2 "red", 3 "orange" ) 
#load "myPalette.pal"
stats "< cut -f3 ".file ;  #<== [OK] and more general
nb_item=STATS_blocks

set macro
sizeXY="1200,800"
set term x11 enhanced size @sizeXY font "LM Sans,8"
# set term x11 enhanced size 1200,600 font "LM Sans,8"
set ylabel font "LM Sans,24"

startDate = "2016-06-27"
stopDate  = "2016-09-30"
stopDate  = "2017-12-31"
nbCat = nb_item #nbCat = 19
DW=0.8 #DW=0.8, DW=0.9, DW=1

timeformat = "%Y-%m-%d"
T(N) = timecolumn(N,timeformat)
BOLD="\x1B[1;37m"
txtBold(x) = sprintf("{/:Bold %s}",x)
OneDay = 60*60*24
TwoDay = OneDay*2
OneWeek = OneDay*7
OneMonth = OneDay*31
OneYear = 365.2425 / 12 * 24 * 3600# = 2629746# I worked this out by assuming 365.2425 days in the average year,

yearStep=365.25 * 24 * 60 * 60


#today = strptime("%d/%m/%Y",system("echo %DATE%"))#<== windows
#today = system("date +\"%Hh%M_%F\"")
today = strptime(timeformat, system("date +\"%F\""))

# TOTEST
set datafile missing "" 
set datafile separator "\t" 

# homemade handy functions
# car : Contents of the Address Register old style function
# ws="0:100"
car(ws)=ws[1:strstrt(ws,":")-1]
cdr(ws)=ws[strstrt(ws,":")+1:-1]
cadr(ws)=car(cdr(ws))

# ws="0:100"
# ws="100"
# ws="10:100"
do for [ws in "0:100 100 10:100"] {pr ws."aa"}
do for [ws in "0:100 100 10:100"] {pr "colon position=".strstrt(ws,":")}


colon(ws)=strstrt(ws,":")==0? "0:".ws :ws
do for [ws in "0:100 100 10:100"] {pr colon(ws)}
Y0(ws)=car(colon(ws))
Y1(ws)=cadr(colon(ws))
do for [ws in "0:100 100 10:100"] {pr "Y0=".Y0(ws)."\tY1=".Y1(ws)}

Y0s(ws)=Y0(stringcolumn(ws))
Y1s(ws)=Y1(stringcolumn(ws))

#strcol(5)[1:strstrt(strcol(5,":"))]

txtBoldNL(x) = int(words(x)) == 1 ? sprintf("{/=8:Bold %s}",word(x,1)) : int(words(x)) == 2 ? sprintf("{/=8:Bold %s} \n {/=8:Bold %s}",word(x,1),word(x,2)) : int(words(x)) == 3 ? sprintf("{/=8:Bold %s} \n {/=8:Bold %s} \n {/=8:Bold %s}",word(x,1),word(x,2),word(x,3)) : int(words(x)) == 4 ? sprintf("{/=6:Bold %s} \n {/=6:Bold %s} \n {/=6:Bold %s} \n {/=6:Bold %s}",word(x,1),word(x,2),word(x,3),word(x,4)) : sprintf("{/:Bold %s}",x)

set border; set bmargin 3.5; set datafile separator "\t";set timefmt "%Y-%m-%d"

set style line 102 lc rgb '#d6d7d9' lt 0 lw 1
set grid xtics x2tics ytics mytics back ls 102
# set timefmt default
set xdata time; set x2data time
#
unset key; unset colorbox
set style data lines
set mxtics 2
#set xtics border in scale 1,0.5 nomirror norotate  autojustify
#set xtics TwoDay norangelimit font ",8" 
#set xtics  OneWeek norangelimit font ",8" rotate by 45 offset -0.8,-0.8
set xtics  yearStep/2  font ",8"#<== twice print/year # rotate by 45 offset -0.8,-0.8
#set xtics  OneYear+1 norangelimit# font ",8" rotate by 45 offset -0.8,-0.8
set x2tics OneWeek norangelimit
#set format x "%d\n" timedate
set format x "%Y" timedate
set format x2 "%U" timedate #<== week number on top 
set xrange [startDate:stopDate]
set link x
#
set ytics border in scale 1,0.5 nomirror norotate  autojustify
set ytics  norangelimit
set ytics   1
set mytics  2
set title "{/=15 Plan de charge}"." \\\_".system("date +\"%F\"")."\\\_"
set yrange [ -1.00000 : nbCat] noreverse nowriteback
set style fill transparent solid 0.3 border
set style textbox opaque noborder
set arrow 1 from first today, graph 0.01 to first today, graph 0.99 lw 3 lc rgb 'red' nohead back
x = 0.0
set samples (strptime(timeformat,stopDate)-strptime(timeformat,startDate))/OneDay+2,100

existq(file)=system(sprintf("[ ! -e %s ]; echo $?", file)) #=0 to cast to a number
if (!exists("type2numFile")) type2numFile="type2num.gp" #load 'type2num.gp'
fileq=system(sprintf("[ ! -e %s ]; echo $?", type2numFile))
if (0+existq(type2numFile)) load type2numFile  #<== or uncomment the comment underneath
# type2num(type) = type eq "Vacances"||type eq "off" ? 1 :type eq "BB130"||type eq "XTRACT" ? 2 : type eq "ENVISION" ||type eq "GAMHADRON" || type eq "CLARYS" || type eq "MEDICAL" ? 3 : type eq "DUNE" || type eq "WA105" ? 4 : type eq "MFT" ? 5 :type eq "BIOCAM" ? 6 : type eq "conf" || type eq "mission" || type eq "formation" ? 7 : type eq "CMSmuon" || type eq "CIC" ? 8 : 9
## Last datafile plotted: file
#	for [i=0:nbCat-1] file 	index i using (T(4)+OneDay+T(3))/2 : (i) : (T(4)+OneDay-T(3))/2 : (0.4) : (type2num(stringcolumn(2))) : yticlabel(1) with boxxy dt i+1 lt i+1 lc variable lw 1,\


#https://stackoverflow.com/questions/30551176/how-to-use-substrings-in-gnuplot
# get_x(c) = 0.0 + substr(strcol(c), strstrt(strcol(c), "(") + 1, strstrt(strcol(c), ",") - 1)
# get_y(c) = 0.0 + substr(strcol(c), strstrt(strcol(c), ",") + 1, strstrt(strcol(c), ")") - 1)
get_y0(c) = 0.0 + substr(strcol(c), strstrt(strcol(c), ":") + 1, strstrt(strcol(c), ",") - 1)
get_y1(c) = 0.0 + substr(strcol(c), strstrt(strcol(c), ",") + 1, strstrt(strcol(c), ")") - 1)
#0.0+strcol(5)[1:strstrt(strcol(5,":"))]


gy0(c)=0.0+strcol(c)[0:strstrt(strcol(c), ":")]/100.0 #<== nicer syntax
#gy1(c)=0.0+substr(strcol(c),strstrt(strcol(c), ":")+1,-1)/100.0
gy1(c)=0.0+strcol(c)[strstrt(strcol(c), ":")+1:-1]/100.0

#gcolon(d)=strstrt(strcol(d),":")==0? "0:".strcol(d) :strcol(d) #<== bugg
gcolon(d)=strstrt(strcol(d),":")==0? "0:".d :d #<== idiot
dy0(e)=-0.5+gy0(gcolon(e))
dy1(e)=-0.5+gy1(gcolon(e))

plot \
	'+' u (tm_wday($1) == 0 ? floor($1/OneDay)*OneDay : 1/0) : (nbCat)/2. : (OneDay) : (nbCat+2)/2. w boxxy fs transparent solid 0.1 noborder lt 7,\
	'+' u (tm_mday($1) == 1 ? floor($1/OneDay)*OneDay : 1/0) : (nbCat)  with impulses lc rgb 'gray',\
	'+' u (tm_mday($1) == 1 ? floor($1/OneDay)*OneDay : 1/0) : (-1)  with impulses lc rgb 'gray',\
     for [i=0:nbCat-1] file index i using (T(3)):(i):(T(3)):(T(4)):(i+(dy0(5))*DW): (i+(dy1(5))*DW) : (type2num(stringcolumn(2))) : yticlabel(1) with boxxy dt i+1 lt i+1 lc palette lw 1,\
     file using (T(4)+OneDay+T(3))/2 : (column(-2)+(int(words(stringcolumn(2)))-1)/8.+(gy1(5)+gy0(5)-1.03)*DW/2.0) : (txtBoldNL(stringcolumn(2))) with labels offset char 0, char 0 font ",6" tc rgb "black",\
	'+' u (tm_mday($1) == 15 ? floor($1/OneDay)*OneDay : 1/0) : (-1) : (strftime("%B",$1)) with labels offset char 0, char -2 font ",12",\
	'+' u (tm_mday($1) == 365/2 ? floor($1/OneDay)*OneDay : 1/0) : (-1) : (strftime("%Y",$1)) with labels offset char 0, char -3 font ",12"

# plot \
#      for [i=0:nbCat-1] file 	index i using (T(4)+OneDay+T(3))/2 : (-0.5+gy0(5)/100) : (T(4)+OneDay-T(3))/2 : (0.5-gy1(5)/100) : (type2num(stringcolumn(2))) : yticlabel(1) with boxxy dt i+1 lt i+1 lc variable lw 1,\
#      file using (T(4)+OneDay+T(3))/2 : (column(-2)+(int(words(stringcolumn(2)))-1)/8.) : (txtBoldNL(stringcolumn(2))) with labels offset char 0, char 0 font ",6" tc rgb "black"
# # [OK]

# plot \
#      for [i=0:nbCat-1] file 	index i using (T(3)) : (i) : (0) : (gy0(5)) : (T(4)) : 0.4 : (type2num(stringcolumn(2))) : yticlabel(1) with boxxy dt i+1 lt i+1 lc variable lw 1
# ## # fail : timecolumn() called from invalid context
## ### normal il faut entourer les fonctions dans using :(func1(x)):(func2(x)):


set term png size @sizeXY
set output sprintf("planning_%s.png", system("date +\"%F\""))
replot
set term pdfcairo enhanced size 21cm,9cm rounded font "Calibri,8"
set output sprintf("planning_%s.pdf", system("date +\"%F\""))
replot
set term x11 enhanced size @sizeXY font "LM Sans,8"
replot

system(sprintf("xwd -id 0x%x | convert xwd:- schedule_%s.png", GPVAL_TERM_WINDOWID,system("date +\"%F\"")))
