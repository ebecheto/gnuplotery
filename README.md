# gnuplotery
my gnuplot tricks gathered here and there

*paraGif* function example
--------------------------
Example of a rotating view of a transfert function. A parameter can be changed when invoking gnuplot, so that, the singularity can be checked.

`gnuplot -e "capL='1000e-15';mapy=1" paraGif.gp -`

![example capL<capf/2](./PZx2_100f.gif)

`gnuplot -e "capL='100e-15';mapy=1" paraGif.gp -`

![example capL>capf/2](./PZ1x_1000e-15.gif)

*mosCarac* function example
--------------------------

Here is an example of the data extracted from a 10u/0.35u MOS transistor, and plotted in three dimentions, so that one can see clearly, on a single graph, all the region of operation of a transistor : [0] Off (blocked), [3] subth (week inversion), [1] triode (ohmic) and [2] saturation.

![MOS transistor caracteistic example ](./carac_v8.png)


*gantt* function example
--------------------------

How to nicely plot time scheddule, so called gantt chart, planning or whatsoever. Thanks to Philou for its first share.

USAGE : 
Modify the file type2Num.gp to select the corresponding  color to a project name. Update the new_plan.txt to your needs. Warning, each block needs to be separated with two blak lines (not space, tab or so), and each row is separated with a tab (could be customized with gnuplot option : separtor=';' or so.)

Or if you have custom names, just invoke, gnuplot like that:

`gnuplot -e "file='MY_dates.txt'; type2numFile='MY_type.gp'" boxxy.gp -`


![team plan ](./schedule_2017-07-18.png)

