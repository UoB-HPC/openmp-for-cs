# OpenMP codes

This project contains a number of OpenMP examples.

A Fortran timing module (itself an interface to a C time call) is also provided as a utility to aid in getting wall clock time for serial Fortran programs.

## Compiling the code
The provided `Makefile` will build all of the provided code.
The default compiler is `gfortran`.

To use your own compiler, edit the `FTN` variable in the `Makefile`.
For example, set `FTN=ifort` to use the Intel Fortran compiler.

Additional compiler flags can be set using the `FFLAGS` variable in the `Makefile`.

The OpenMP library is set using the `LIBS` variable in the `Makefile`.

Run `make clean` to clear away the built binaries and partial build files.

## Vector Addition

Serial and parallel versions of the simple vector add program: `C=A+B`.
Both a SPMD and a `parallel do` parallel version are provided (as solutions).

## 5-point stencil

Serial and parallel versions of a simple 5-point stencil on a rectangular grid.
The value in each cell is computed as the average (mean) of itself and north, south, east and west neighbours.
The stencil is applied to the grid a number of times.

## Pi

This code implements the integration of `4/(1+x*x)` using the trapezoidal rule to estimate pi.

A number of implementations are given, and should be viewed in order:

1. pi: the serial version
2. critical: an initial parallel version, using a critical region to safeguard sum
3. atomic: parallel version, using an atomic to safeguard sum
4. array: parallel version, using an array of partial sums, one per thread
5. private: parallel version, using a private sum to each thread, totalled with a critical
6. reduction: parallel version using OpenMP reduction

## Private

This code is a simple example to show how different private data sharing clauses change the data environment of each thread.


## Fibonacci
An implementation of a recursive algorithm to calculate Fibonacci numbers using OpenMP tasks.


## Jacobi

This code implements the iterative Jacobi method to solve a system of linear equations.
See the [Wikipedia page](https://en.wikipedia.org/wiki/Jacobi_method) for a full description of the Jacobi method.

The program can be run without any arguments to solve a default problem.
The `-n` and `-i` arguments can be used to control the matrix size and maximum number of iterations.
For example, to solve for a 500x500 matrix, use the following command:

    ./jacobi -n 500

Use `--help` to see a full description for all of the command-line arguments.

### Sample runtimes

Here are the runtimes that we achieve with the starting code for a few different matrix sizes.
Run on a MacBook Pro (Intel Core i7-4980HQ CPU @ 2.80GHz).

| Matrix size | Solver runtime  | Iterations | Solution error   |
| ----------- | --------------- | ---------- | ---------------- |
|     500     |  0.331 seconds  |    1511    |    0.0248609     |
|    1000     |  4.858 seconds  |    2883    |    0.0499393     |
|    2000     |  170   seconds  |    5445    |    0.0999166     |
|    4000     |  1671  seconds  |    10233   |    0.1998391     |

## Utility timing routines
The `timer.f90` and `wtime.c` files provide a simple timing routine to use for all examples.
The time is recorded in C using `gettimeofday()`, and a Fortran interface is provided.
This was provided so that the serial codes can use a simple timing library.
Users should use the OpenMP `omp_get_wtime()` API call for their parallel codes.

