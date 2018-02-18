
FTN=gfortran
FFLAGS=-Wall -O3
LIBS=

default: all

all: jacobi pi

jacobi: jacobi.f90 wtime.o
	$(FTN) $(FFLAGS) $^ $(LIBS) -o $@

%:%.f90 timer.o wtime.o
	$(FTN) $(FFLAGS) $^ $(LIBS) -o $@

timer.o: timer.f90
	$(FTN) -O3 $< -c

%.o: %.c
	$(CC) -O3 $< -c

.PHONY: clean
clean:
	rm -f *.o *.mod jacobi pi
