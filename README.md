# OpenMP codes

This project contains a number of OpenMP examples.

A Fortran timing module (itself an interface to a C time call) is also provided as a utility to aid in getting wall clock time for serial Fortran programs.

## Pi

This code implements the integration of `4/(1+x*x)` using the trapezoidal rule to estimate pi.



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
