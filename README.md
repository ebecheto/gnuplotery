# gnuplotery
my gnuplot tricks gathered here and there

*paraGif* function example
--------------------------
Example of a rotating view of a transfert function. A parameter can be changed when invoking gnuplot, so that, the singularity can be checked.

`gnuplot -e "capL='1000e-15';mapy=1" paraGif.gp -`.

`gnuplot -e "capL='100e-15';mapy=1" paraGif.gp -`



# ![example capL<capf/2](./PZx2_100f.gif)
# ![example capL>capf/2](./PZ1x_1000e-15.gif)

<img align="left" src="./PZx2_100f.gif">
<img align="right" src="./PZ1x_1000e-15.gif">
