# OpenMP codes

This project contains a number of OpenMP examples.

A Fortran timing module (itself an interface to a C time call) is also provided as a utility to aid in getting wall clock time for serial Fortran programs.

## Vector Addition

Serial and parallel versions of the simple vector add program: `C=A+B`.


## 5-point stencil

Serial and parallel versions of a simple 5-point stencil on a rectangular grid.
The value in each cell is computed as the average (mean) of itself and north, south, east and west neighbours.
The stencil is applied to the grid a number of times.


## Pi

This code implements the integration of `4/(1+x*x)` using the trapezoidal rule to estimate pi.

A number of implementations are given, and should be viewed in order

1. pi: the serial version
2. critical: an initial parallel version, using a critical region to safeguard sum
3. atomic: parallel version, using an atomic to safeguard sum
4. array: parallel version, using an array of partial sums, one per thread
5. private: parallel version, using a private sum to each thread, totalled with a critical
6. reduction: parallel version using OpenMP reduction

## Jacobi

This code implements the iterative Jacobi method to solve a system of linear equations.
See the [Wikipedia page](https://en.wikipedia.org/wiki/Jacobi_method) for a full description of the Jacobi method.

### Compiling and running

The code can be compiled by typing `make`. To change the compiler or flags, you should modify the Makefile.

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
