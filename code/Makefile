
FTN=ftn
CC=cc
FFLAGS=-Wall -O3
LIBS=-homp -rm

TIMEOBJ=timer.o wtime.o

default: all

BINS=jacobi pi pi_critical pi_atomic pi_array pi_private pi_reduction private vadd vadd_paralleldo vadd_spmd stencil stencil_paralleldo stencil_reduction stencil_optimised stencil_numa stencil_target fibonacci tasks

all: $(BINS)

%:%.f90 $(TIMEOBJ)
	$(FTN) $(FFLAGS) $^ $(LIBS) -o $@

%.o:%.f90
	$(FTN) -O3 $< -c

%.o: %.c
	$(CC) -O3 $< -c

.PHONY: clean
clean:
	rm -f *.o *.mod $(BINS)
