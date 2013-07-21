#!/bin/bash

ARCH=quad
MAX_SIZE=35000
FLAG=0
ZERO=0

[[ -z $COMPILER ]]

if [[ $COMPILER="gcc" ]] && COMPILER="gcc"; then
     make compilequad > /dev/null
     #make compilequadoptimized > /dev/null
     if [ $FLAG -eq $ZERO ]; then
        for i in $(seq 34200 200 35000)
        do
	    ./main_quad $i $ARCH >> out_quad_imo5.txt
	    #./improved_quad $i $ARCH >> out_quad_improved_o3_v2.txt
	done
     else
	    #./main_quad $MAX_SIZE $ARCH >> out_05.txt
	    ./improved_quad $MAX_SIZE $ARCH >> out_improved_o3.txt
    fi
fi
