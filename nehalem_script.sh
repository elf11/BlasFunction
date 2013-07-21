#!/bin/bash

ARCH=nehalem
MAX_SIZE=35000
FLAG=0
ZERO=0

[[ -z $COMPILER ]]

if [[ $COMPILER="gcc" ]] && COMPILER="gcc"; then
    make compilenehalem > /dev/null
    #make compilenehalemoptimized > /dev/null
    if [ $FLAG -eq $ZERO ]; then
        for i in $(seq 34200 200 35000)
        do
	    ./main_nehalem $i $ARCH >> out_nehalem_imo5.txt
	    #./improved_nehalem $i $ARCH >> out_nehalem_improved_o3_v2.txt
	done
    else
	    #./main_nehalem $MAX_SIZE $ARCH >> out_o5.txt
	    ./improved_nehalem $MAX_SIZE $ARCH >> out_improved_o3.txt 
    fi
fi
