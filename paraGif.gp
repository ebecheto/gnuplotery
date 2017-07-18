# gnuplot -e "capL='1000e-15 100e-15';mapy=1" paraGif.gp -
# gnuplot -e "capL='1000e-15';mapy=1" paraGif.gp -
# gnuplot -e "capL='100e-15';mapy=1" paraGif.gp -

file='multiplot.gp'#<== for init_margins, set_margins function : (not obliged)
if (system(sprintf("[ -e %s ]; echo $((!$?))", file))); {
 load file; pr file." Loaded"}
#set title "Transfert Function"
f(x,y) = atanh(x + y*{0,1})
# laplace notation s replaced by complex x+jw  where j (or i) is {0,1}
s(x,w)=x + w*{0,1}

R=3.25e6 # 6.5M Ohm half resistor cut in middle by the parasitic's one
# Cp=500e-15
Cf=260e-15
H(s, Cp)=(2*R+R**2*Cp*s)/(1+s*Cf*R*(s*Cp*R+2))
dB(x) = 20 * log10(abs(x))

set grid
set logscale x 10
set logscale y 10 #<== not need if plotted in dB

rangeMin=10
rangeMax=1e12
rangeMin=1e4
rangeMax=1e8
zi=1e5 # rangeMin
zi=100 # rangeMin
za=1e9 # rangeMax

set xrange [rangeMin:rangeMax]
set yrange [rangeMin:rangeMax]
set grid mx2tics
set grid my2tics
set logscale z

#set hidden3d
if (!exist("mapy")){mapy=0}
arrows=0
cont=0
nokey=1
verb=0 #<= verbose if verb=1 nor verbose if verb=0
VX=70; VY=8

# png output
set terminal pngcairo size 1024, 768 enhanced font 'Verdana,10'

# if (!exist("ilist")) {ilist="";do for [ii=0:90:1] {ilist=ilist." ".ii}}
# do for [ii in ilist] { pr ii}

do for [ii=0:90:1] {
 set output sprintf('PZ_3d_%03.0f.png',ii)
 # set output sprintf('PZ_3d_%03.0f.jpg',ii)
 VX=ii
 # pr VX, VY; #<== commentaire
 set isosamples 25, 25
 set format z "%.1s%c"
 if (mapy){VX=0; VY=0;set format z "";set isosamples 100, 100}
 SX=0.5;SY=0.5
 # set zlabel 'H(s)' offset 0,15,0; #<== verify
 set xyplane at 1e-6 # si range 1000 1e12
 set xyplane at 1e4 # si range 10 1e12
 if (cont) {set contour
 #set cntrparam levels auto 30
 set cntrparam bspline
 }
 if (nokey) {unset key}

 if (arrows) {
 X0=1e4; Y0=1e4; Z0=100
 Rsize=1e5 #<= repere size
 X1=X0+Rsize
 Y1=Y0+Rsize
 Z1=Z0+Rsize
 set arrow 1 from X0,Y0,Z0 to X1,Y0,Z0 lw 1.5 lc rgb 'red'
 set arrow 2 from X0,Y0,Z0 to X0,Y1,Z0 lw 1.5 lc rgb 'green'
 set arrow 3 from X0,Y0,Z0 to X0,Y0,Z1 lw 1.5 lc rgb 'blue'
 }

 set logscale cb
 set cbrange[1e5:1e8]
 set palette defined ( 0 "#2C2F33", 1 "#36B500", 2 "orange", 3 "red") 

 if (mapy) {set hidden3d; set pm3d map ; pr "Map ON:".mapy} else { set pm3d at s; set style fill transparent solid 0.65 border}
 if (!exist("capL")) {capL='1e-12'}
 caps(n)=word(capL,n)
 N=words(capL)

 set cbrange[1e5:3e7]
 set format cb "%.1s%c"

 unset grid

 #    init_margins(left, right, bottom, top,  dx,   dy,   rows, cols)
 if (exist("GPFUN_init_margins")) {eval(init_margins(0.1,  0.89,  0.06,    0.98, 0.08, 0.08, 2,     2))}

 set multiplot

 if (exist("GPFUN_set_margins")) {eval(set_margins(2,1))}
 #set size SX,SY; set origin 0.5,0.5
 #set xlabel "Re" offset 0,-5 ;# set ylabel "Im"
 set xlabel "Re" offset 0,-18 ; set ylabel "Im"
 set zrange [zi:za] noreverse
 set view (VX+360) %360, (VY+360) %360;
 set title "quadrant x+jy"
 set format y ""; set format x ""; set format z ""
 set colorbox horizontal user origin 0.1,.04 size 0.8,.03
 splot for [i=1:N] abs(H(s(x,y),caps(i)))

 if (exist("GPFUN_set_margins")) {eval(set_margins(1,1))}
 #set size SX,SY; set origin 0,0.5
 set xlabel "-Re" offset 0,-2;
 set ylabel "Im"
 set zrange [zi:za] noreverse
 set view (180-VX+360)%360,(180-VY+360)%360
 set title "quadrant -x+jy"." ( Cpar=".caps(i)." )"
 unset colorbox
 set format y "%.1s%c"; set format x ""; if (!exist("mapy")) {set format z "%.1s%c"}
 splot for [i=1:N] abs(H(s(-x,y),caps(i)))
 splot for [i=1:N] (x<2e4) ? abs(H(s(-x,y),caps(i))) :1/0 lt -1 #<= bode transfert func when Re=0 and +Im

 if (exist("GPFUN_set_margins")) {eval(set_margins(1,2))}
 #set size SX,SY; set origin 0,0
 set ylabel "-Im"; #set xlabel "-Re";
 # set view (VX+270+360)%360,(VY+180+360)%360
 set view (360-VX+360)%360,(180+VY+360)%360
 set zrange [zi:za] reverse
 set title "quadrant -x-jy"
 unset colorbox
 set format y "%.1s%c";set format x "%.1s%c"; set xtics offset 0,-15.3
 splot for [i=1:N] abs(H(s(-x,-y),caps(i)))
 set xtics nooffset

 if (exist("GPFUN_set_margins")) {eval(set_margins(2,2))}
 # set size SX,SY; set origin 0.5,0
 set xlabel "Re" offset 0,18;set ylabel "-Im"
 set zrange [za:zi] reverse  #<= pas za zi ?
 set title "quadrant +x-jy"
 set view (VX+180+360)%360,(360-VY+360)%360
 unset colorbox
 set format y "";set format x "%.1s%c"; set format z ""
 splot for [i=1:N] abs(H(s(x,-y),caps(i)))

 unset multiplot
 show output
 unset output
}

S=strstrt(capL," ")
if(S==0) {pName=capL} else {pName=capL[1:strstrt(capL," ")-1]."_".capL[1+strstrt(capL," "):*]}

cmd=sprintf("! convert -resize 480x360  PZ_3d_*.png -delay 20  -layers OptimizeTransparency +map  PZ1x_%s.gif", pName)

eval cmd
pr cmd

pr sprintf("PZ1x_%s.gif", pName).". Printed"

# ! convert -size 480x360  PZ_3d_*.png -delay 20  -layers OptimizeTransparency +map  PZ2_100f.gif
