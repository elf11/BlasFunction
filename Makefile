#
# Author: NICULAESCU OANA
#               331CB
# 
# CC=gcc
#
CC=gcc -g

CFLAGS_opteron="-I/opt/tools/libraries/atlas/3.10.1-opteron-gcc-4.4.6/include"
LDFLAGS_opteron="-L/opt/tools/libraries/atlas/3.10.1-opteron-gcc-4.4.6/lib"
CFLAGS_opteron_optimized="-march=amdfam10 -msse4a --param l1-cache-line-size=64 --param l1-cache-size=64 --param l2-cache-size=512"

CFLAGS_nehalem="-I/opt/tools/libraries/atlas/3.10.1-nehalem-gcc-4.4.6/include"
LDFLAGS_nehalem="-L/opt/tools/libraries/atlas/3.10.1-nehalem-gcc-4.4.6/lib"
CFLAGS_nehalem_optimized="-mtune=generic -msse4.2 --param l1-cache-line-size=64 --param l1-cache-size=32 --param l2-cache-size=256"

CFLAGS_quad="-I/opt/tools/libraries/atlas/3.10.1-quad-gcc-4.4.6/include"
LDFLAGS_quad="-L/opt/tools/libraries/atlas/3.10.1-quad-gcc-4.4.6/lib"
CFLAGS_quad_optimized="-mtune=generic -msse4.1 --param l1-cache-line-size=64 --param l1-cache-size=32 --param l2-cache-size=6144"

CFLAGS_gcc="-O5"
CFLAGS_gcc_optimized=-O3 -funroll-loops -mfpmath=sse -minline-all-stringops -mcx16 -m64 -ftree-loop-distribution

compile: compilequad compileopteron compilenehalem compilequadoptimized compileopteronoptimized compilenehalemoptimized

compilequad:
	$(CC) -o main_quad $(CFLAGS_quad) $(CFLAGS_gcc) main.c $(LDFLAGS_quad) -lcblas -latlas

compilequadoptimized:
	$(CC) -o improved_quad $(CFLAGS_quad) $(CFLAGS_gcc_optimized) main.c $(LDFLAGS_quad) -lcblas -latlas

compileopteron:
	$(CC) -o main_opteron $(CFLAGS_opteron) $(CFLAGS_gcc) main.c $(LDFLAGS_opteron) -lcblas -latlas

compileopteronoptimized:
	$(CC) -o improved_opteron $(CFLAGS_quad) $(CFLAGS_gcc_optimized) main.c $(LDFLAGS_quad) -lcblas -latlas


compilenehalem:
	$(CC) -o main_nehalem $(CFLAGS_nehalem) $(CFLAGS_gcc) main.c $(LDFLAGS_nehalem) -lcblas -latlas

compilenehalemoptimized:
	$(CC) -o improved_nehalem $(CFLAGS_quad) $(CFLAGS_gcc_optimized) main.c $(LDFLAGS_quad) -lcblas -latlas


run:clean
	./main_quad ; ./main_opteron ; ./main_nehalem
clean:
	rm -Rf main_quad main_opteron main_nehalem improved_quad improved_opteron improved_nehalem
