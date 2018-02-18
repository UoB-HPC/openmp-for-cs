
FTN=gfortran
FFLAGS=-Wall -O3
LIBS=-fopenmp

TIMEOBJ=timer.o wtime.o

default: all

all: jacobi pi

jacobi: jacobi.f90 $(TIMEOBJ)
	$(FTN) $(FFLAGS) $^ $(LIBS) -o $@

%:%.f90 $(TIMEOBJ)
	$(FTN) $(FFLAGS) $^ $(LIBS) -o $@

%.o:%.f90
	$(FTN) -O3 $< -c

%.o: %.c
	$(CC) -O3 $< -c

.PHONY: clean
clean:
	rm -f *.o *.mod jacobi pi
