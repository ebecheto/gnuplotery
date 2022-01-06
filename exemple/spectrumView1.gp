YUNIT="dBm"
XUNIT="Hz"
XZERO=625.6884000E+6
XINCR=263.1578947368421E+3
set tics format "%.1s%c"
set xtics right rotate by 45
set ylabel "[".YUNIT."]"
set xlabel "[".XUNIT."]"
WFID="CH1_SV_NORMAL, 1902 points, Center Freq: 875.6884MHz, Span: 500MHz"
file='spectrumView1.dat'
plot file u (XZERO+$0*XINCR):1 w lp t WFID
set label 1 gprintf("%.2s%c", 656.2147157894736E+6) at 656.2147157894736E+6,-44.7485275268555  left
set label 2 gprintf("%.2s%c", 875.1620842105261E+6) at 875.1620842105261E+6,1.1732465028763  left
set label 3 gprintf("%.2s%c", 983.8462947368420E+6) at 983.8462947368420E+6,-46.6100578308105  left
set label 4 gprintf("%.2s%c", 1.0938462947368E+9) at 1.0938462947368E+9,-41.1013565063477  left
old_term=GPVAL_TERM
set term pngcairo font "Sans,9"
outfile=file[0:strstrt(file, ".")-1].".png"
set output outfile; replot; pr "[".outfile."] saved"
set t old_term 0 font "Sans,9"; replot
