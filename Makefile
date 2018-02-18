
FTN=gfortran
FFLAGS=-Wall -O3
LIBS=

default: all

all: jacobi pi

jacobi: jacobi.f90 wtime.o
	$(FTN) $(FFLAGS) $^ $(LIBS) -o $@

%:%.f90
	$(FTN) $(FFLAGS) $^ $(LIBS) -o $@

%.o: %.c
	$(CC) -O3 $< -c

.PHONY: clean
clean:
	rm -f *.o *.mod jacobi pi
