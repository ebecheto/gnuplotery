nbKM=42.195
dDay="25 Septembre 2016"
ouca="Run In Moscow"
set title titre=sprintf("%d Km %s __%s__", nbKM,ouca,dDay)
#wget marche pas suivant le javascript utilise
#http://www.aso.fr/massevents/resultats/index.php?langue=fr&course=rlm15&version=3&xdm_e=http%3A%2F%2Fwww.runinlyon.com&xdm_c=default6082&xdm_p=1
# cat scratch.html | grep -v "Dossard\|^Nom\|^Prenom\|^Sexe\|^Recherche\|^Cat\|^$\||\|sultats$" > dump.txt
# cat res.txt |grep -v "Honlapk\|^ *$\|^Fax\|^Phone\|^Addre\|^Copy\|^Email\|^<<\|^Results\|^race\|name of\|^sex of\|^club\|^city\|^country\|^net time\|^from\|^(hour\|^rank\|^lines\|^pos\|^Search\|^Please\|^(rank\|^2015\. 10\|^ to\|^If you" > tmp

#! awk 'NF>1{print $NF}' all.dat > results.dat

file='res.txt' 
# cat res.txt | grep -o '[0-9][0-9]:[0-9][0-9]:[0-9][0-9]' > result
HF=" Homme+Femme"
# !cat tmp | grep -o ' M ' > result
# !cat tmp | grep -P '\tM\t' * > result.M
# !cat tmp | grep -P '\tF\t' * > result.F
# !cat tmp |sed -n  "/        M       /p" > result.M #<= C-v <TAB> pour inserer une tabulation
# ! wc result.M
# ! awk 'NF>1{print $NF}' result.M > results.dat
HF="Homme"
# !cp results.dat times.dat


# ________________________________________________________________________________

# set table OK with	Version 4.2 patchlevel 6
set xdata time
set timefmt "%H:%M:%S"
# set xrange ["01:00:00":"03:00:00"]
fmt = '%Y-%m-%d %H:%M:%S'
# jour='2012-10-07'
jour='2000-01-01'
bw=50
bw=60
plot 'times.dat'  u (bw*floor(strptime(fmt,jour.stringcolumn(1))/bw)):(1) smooth frequency w histeps
set table 'semiDB.dat'
unset xdata
plot 'times.dat'  u (bw*floor(strptime(fmt,jour.stringcolumn(1))/bw)):(1) smooth frequency w histeps
unset table
pr jourHeure=strftime(fmt,7000). '. With bin='. strftime("%H:%M:%S",bw)
pr jourHeure
set xdata time
hms="%H:%M:%S"
set timefmt "%H:%M:%S"
set xrange ["01:00:00":"07:00:00"]
plot 'times.dat'  u (strftime(hms,bw*floor(strptime(fmt,jour.stringcolumn(1))/bw))):(1) smooth frequency w histeps

pr Yend=floor(GPVAL_DATA_Y_MAX*1.2)


system("cat 'semiDB.dat'| sed -e '/^#/d; /^$/d' > semiDB2.dat")

fileLength="`cat semiDB2.dat| wc -l `"
pr mline=floor(fileLength/2)
pr corde=sprintf("cat 'semiDB2.dat'|sed -n '%dp'|awk '{print $1}'", floor(fileLength/2))
pr estimPos=system(corde)
pr corde=sprintf("cat 'semiDB2.dat'|sed -n '%dp'|awk '{print $1}'", floor(fileLength/12))
pr estimSig=system(corde)
pr corde=sprintf("cat 'semiDB2.dat'|sed -n '%dp'|awk '{print $1}'", fileLength-1)
pr estimLast=system(corde)
pr corde=sprintf("cat 'semiDB2.dat'|sed -n '%dp'|awk '{print $1}'", 1)
pr estimFirst=system(corde)

pr Xend=strftime("%H:%M:%S",estimLast*1.2)
pr Xbeg=strftime("%H:%M:%S",estimFirst*0.5)#<= il y a qd meme plus de coureur a la traine

binwidth=10
set boxwidth binwidth
bin(x,width)=width*floor(x/width) + binwidth/2.0
#reset
position=estimPos
sigma=estimSig
pr estimSig, " ", estimPos
# amplitude ?? si fit marche pas, mettre la valeur estime a l'oeuil 0.4*max
amplitude=100
gauss(x) = amplitude/(sigma*sqrt(2.*pi))*exp(-(x-position)**2/(2.*sigma**2))
# unset xrange
unset xdata
fit gauss(x) 'semiDB.dat' via amplitude, position, sigma
plot gauss(x), 'semiDB.dat'
set xdata time

#[:Yend]
#arange=[Xbeg:Xend]#<== marche pas invalid expression
# set xrange ["01:00:00":"03:00:00"] writeback
# Xbeg="01:00:00"
# Xend="03:00:00"

plot  [Xbeg:Xend] 'times.dat'  u (strftime(hms,bw*floor(strptime(fmt,jour.stringcolumn(1))/bw))):(1) smooth frequency w histeps, gauss(x)
# plot  ["01:00:00":"03:00:00"] 'times.dat'  u (strftime(hms,bw*floor(strptime(fmt,jour.stringcolumn(1))/bw))):(1) smooth frequency w histeps, gauss(x)
# replot

nbPart="`wc -l 'times.dat'| sed "s/ .*//" `"
# pr 'mean='.strftime("%H:%M:%S",position)
sumLabel="\n"
sumLabel=sumLabel.nbPart."  participants".HF."\n\n"
sumLabel=sumLabel."bin=".strftime("%H:%M:%S",bw)."\nmean=".strftime("%H:%M:%S",position) ."\n"."sigma=".strftime("%H:%M:%S",sigma)."\nmean-sigma=".strftime("%H:%M:%S",position-sigma)."\nmean-3*sigma=".strftime("%H:%M:%S",position-3*sigma)

pr sumLabel

# set label sumLabel at graph sigma, 140; replot
# set label 10 sumLabel at graph "06:20:00", 40 right; replot
# set label 10 sumLabel at 12000, 40 right; replot
Xc=(GPVAL_DATA_X_MAX-GPVAL_DATA_X_MIN)/15
Yc=(GPVAL_DATA_Y_MAX-GPVAL_DATA_Y_MIN)/15

set label 10 sumLabel at GPVAL_DATA_X_MAX*1.15, GPVAL_DATA_Y_MAX-Yc right; replot
# set label 10 sumLabel at 10000, 250  right; replot
# set label 10 sumLabel at 9900, 160  right; replot

pr  GPVAL_DATA_X_MAX, GPVAL_DATA_Y_MAX 
 pr strptime("%H:%M:%S","02:45:00")
 pr strptime("%H:%M:%S","06:20:00")
# set title sumLabel; replot
# unset title 

# pr strftime("%H:%M:%S",position)
# pr gauss(strptime("%H:%M:%S",'01:30:00'))
# set xtics nomirror out rotate by -45
# position=7000
# sigma=2000
# amplitude=150

set arrow 1 from position,0 to position, gauss(position)  nohead lw 0.1; replot
# set arrow 1 from 7000,0 to 7000, 140 lw 0.5

replot
ymax10=gauss(position)+10
sy=gauss(position-sigma)
pr HM=gauss(position)/2# 80# Half Maximum = amplitude/2
set arrow 2 from position,sy to position-sigma,sy lw 0.1
set label 1 'sigma' at (2*position-sigma)/2, sy+Yc/2 centre; replot
set label 2 ' Mean='.strftime("%H:%M:%S",position)  at position, Yc left
# X=strptime(fmt,jour.'01:47:00')
# pr X=position-3*sigma
# pr X=GPVAL_DATA_X_MIN
pr X0=GPVAL_X_MIN
pr Xd=(GPVAL_X_MAX-GPVAL_X_MIN)/100
pr Yd=(GPVAL_Y_MAX-GPVAL_Y_MIN)/80
# set label 3 'X' at X+Xd, Y center; replot
# pr Y=GPVAL_DATA_Y_MAX

pr X=X0+Xd
pr Xc=X0+20*Xd
Y=GPVAL_DATA_Y_MAX
Y=110

# pr "Yc step?=".(GPVAL_DATA_Y_MAX-GPVAL_DATA_Y_MIN)/10

Y=Y-Yc

Xr=GPVAL_X_MAX*0.98
pr Xrc=GPVAL_X_MAX-20*Xd
Yr=Y

replot


# eval sprintf("!grep -i %s  %s", 'gir', file)
eval sprintf("!grep -i %s  %s", 'zoccar', file)
# eval sprintf("!grep -i %s  %s", 'dahou', file)
# eval sprintf("!grep -i %s  %s", 'guer', file)
# TODO : Add here the name and times of the ones you know or that you want to plot.


nc=''
nc=nc.';'."surname LASTNAME_3:54:33"
nc=nc.';'."team member2_3:51:38"
nc=nc.';'."team member3_3:51:01"
nc=nc.';'."Mr1_3:50:48"
nc=nc.';'."Mr2_3:48:49"
nc=nc.';'."Mr3_3:48:39"
nc=nc.';'."etc._3:41:25"

nc=nc.';'."team 2_4:04:48"
nc=nc.';'."team 3_4:07:40"
nc=nc.';'."runner x_4:07:52"
nc=nc.';'."hello World_4:10:39"

pr nc


# # nameLabel(nom,crono,dist)=sprintf("tpsx=strptime(fmt,jour.'%s');set arrow from X,Y to Xc, Y nohead lw 0.1;set arrow from Xc,Y to '%s', gauss(tpsx) lw 0.1;set label '%s'.' '.'%s' at X,Y+Yd left;Y=Y-Yc", crono, crono, nom, crono )
# # eval nameLabel("DOIZON", '01:54:00')
# # ok^^^work



nameLabel(nom,crono,dist)=sprintf("tpsx=strptime(fmt,jour.'%s');set arrow from X,Y to Xc, Y nohead lw 0.1;set arrow from Xc,Y to '%s', gauss(tpsx) lw 0.1;set label '%s'.' '.'%s'.' %.2f Km/h' at X,Y+Yd left;Y=Y-Yc", crono, crono, nom, crono, dist/strptime(fmt,jour.crono)*3600)

nameLabelr(nom,crono,dist)=sprintf("tpsx=strptime(fmt,jour.'%s');set arrow from Xr,Yr to Xrc, Yr nohead lw 0.1;set arrow from Xrc,Yr to '%s', gauss(tpsx) lw 0.1;set label '%s'.' '.'%s'.' %.2f Km/h' at Xr,Yr+Yd right;Yr=Yr-Yc", crono, crono, nom, crono, dist/strptime(fmt,jour.crono)*3600)


#eval nameLabel("DOIZON", '01:54:00', 21)

# FONCTION SPECIFIQUE a la facon dont j'ai collecte les donnes : prendre la ligne d'apres
# name2tps(name)=sprintf("grep -i -A1 \"%s\" wget2/index*|tail -n 1|grep -o '[0-9]:[0-9][0-9]:[0-9][0-9]'", name)


sep=";"
cut="_"

# pr S=strstrt(tmp,sep)
# tmp=tmp[2:-1]
# pr car=tmp[1:S-1]
# pr S=strstrt(car,cut)
# if(S!=0) {pr "NOT ZERO"} else {pr "ZERO"}
# pr tmp[1:S]

tmp=nc
while(strlen(tmp)) {
S=strstrt(tmp,sep)
if(S==1) {tmp=tmp[2:-1]; S=strstrt(tmp,sep)}
car=tmp[1:S-1]
cdr=tmp[S+1:-1]
pr 'take '.car
C=strstrt(car,cut)
name=car[1:C-1]
crono=car[C+1:-1]
pr name.' a fait le crono:'.crono
if(strptime(fmt,jour.crono)<position) {
eval nameLabel(name,crono, nbKM)}; else {
eval nameLabelr(name,crono, nbKM)}
tmp=cdr
if(S==0){pr 'End of Loop '.tmp.'___' ; tmp=''}#<= stop condition
}

replot

set xrange ["01:00:00":"03:00:00"] writeback
show xrange
replot
show xrange
unset autoscale x
