as startup.s -o startup.o
as startupTrace.s -o startupTrace.o
(cd ..; gcc -c -O -DI486 -DMACH_O64 scon.c)
(cd ..; gcc -c -O -DUSE_CLIB -DLINUX -DI486 -DGNU_C -DMACH_O64 -o macho64/ufileIO2.o ./ufileIO2.c)
as afileIO3.s -o afileIO3.o
# Because of a bug in ld, the following does not work anymore (MacOSX 10.7 and 10.8)
# ld -r startup.o ../scon.o afileIO3.o ufileIO2.o -o _startup.o
libtool -static -o _startup.o startup.o ../scon.o afileIO3.o ufileIO2.o
# Because of a bug in ld, the following does not work anymore (MacOSX 10.7 and 10.8)
# ld -r startupTrace.o ../scon.o afileIO3.o ufileIO2.o -o _startupTrace.o
libtool -static -o _startupTrace.o ../scon.o afileIO3.o ufileIO2.o
