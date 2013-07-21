#!/bin/bash

plot="draw_graphs.gnu"
out_file=$1
name=$2
file_name=$3
temp="plot_temp.pg"

sed -e s/XXXX/$out_file/g -e s/ZZZZ/$name/g -e s/YYYY/$file_name/g <$plot > $temp
gnuplot $temp
rm $temp
