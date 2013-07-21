#!/bin/bash

ARCH=opteron
MAX_SIZE=35000
FLAG=0
ZERO=0


[[ -z $COMPILER ]]

if [[ $COMPILER="gcc" ]] && COMPILER="gcc"; then
    make compileopteron > /dev/null
    #make compileopteronoptimized > /dev/null
    if [ $FLAG -eq $ZERO ]; then
        for i in $(seq 34200 200 35000)
        do
	    ./main_opteron $i $ARCH >> out_opteron_imo5.txt
	    #./improved_opteron $i $ARCH >> out_opteron_improved_o3_v2.txt
	done
    else
	    #./main_opteron $MAX_SIZE $ARCH >> out_o5.txt
	    ./improved_opteron $MAX_SIZE $ARCH >> out_improved_o3.txt
    fi
fi
