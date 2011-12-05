as startup.s -o startup.o
as startupTrace.s -o startupTrace.o
(cd ..; cc -c -O -DI486 -DMACH_O64 scon.c)
(cd ..; cc -c -O -DUSE_CLIB -DLINUX -DI486 -DGNU_C -DMACH_O64 -o macho64/ufileIO2.o ./ufileIO2.c)
as afileIO3.s -o afileIO3.o
ld -r startup.o ../scon.o afileIO3.o ufileIO2.o -o _startup.o
ld -r startupTrace.o ../scon.o afileIO3.o ufileIO2.o -o _startupTrace.o
