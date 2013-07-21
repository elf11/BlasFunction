#!/bin/bash
#
# Author: Heri
#
# Script de submitere a job-urilor pe fiecare coda, folosind compilatoare diferite
#

#make clean
#make

#qdel -f -u oana.niculaescu

mprun.sh --job-name Opteron --queue ibm-opteron.q \
	--modules "libraries/atlas-3.10.1-gcc-4.4.6-opteron" \
	--script opteron_script.sh --show-qsub --show-script --batch-job
mprun.sh --job-name Nehalem --queue ibm-nehalem.q \
	--modules "libraries/atlas-3.10.1-gcc-4.4.6-nehalem" \
	--script nehalem_script.sh --show-qsub --show-script --batch-job
mprun.sh --job-name Quad --queue ibm-quad.q \
	--modules "libraries/atlas-3.10.1-gcc-4.4.6-quad" \
	--script quad_script.sh --show-qsub --show-script --batch-job

