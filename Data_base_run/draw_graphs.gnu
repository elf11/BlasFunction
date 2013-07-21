#
# Niculaescu Oana
# 331 CB
#
# Script de plot pentru grafice.
#
#
#
reset
set terminal png font "arial,10" fontscale 1.0 size 750, 450
set output "XXXX"
set boxwidth 0.9 absolute
set style fill   solid 1.00 border lt -1
set grid
set ylabel "Time [s]"
set xlabel "Matrix Dimension"
set style histogram clustered gap 5 title  offset character 0, 0, 0
set style data histograms
set xtics border in scale 0,0 nomirror rotate by -45  offset character 0, 0, 0 autojustify
set xtics  norangelimit font ",8"
set xtics   ()
set title "ZZZZ" 
set ytics 0.5
set yrange [ 0.00000 : 15.50000 ] noreverse nowriteback
plot "YYYY" using 3:xtic(2) title "my_func", '' using 4 title "cblas_func"
replot
