# Jacobi

This code implements the iterative Jacobi method to solve a system of linear equations.
See the [Wikipedia page](https://en.wikipedia.org/wiki/Jacobi_method) for a full description of the Jacobi method.

## Compiling and running

The code can be compiled by typing `make`. To change the compiler or flags, you should modify the Makefile.

The program can be run without any arguments to solve a default problem.
The `-n` and `-i` arguments can be used to control the matrix size and maximum number of iterations.
For example, to solve for a 500x500 matrix, use the following command:

    ./jacobi -n 500

Use `--help` to see a full description for all of the command-line arguments.

## Sample runtimes

Here are the runtimes that we achieve with the starting code for a few different matrix sizes.

| Matrix size | Solver runtime | Iterations | Solution error |
| ----------- | -------------- | ---------- | -------------- |
|     500     |  1.48 seconds  |    1465    |    0.02495     |
|    1000     |  10.9 seconds  |    2957    |    0.05005     |
|    2000     |   130 seconds  |    5479    |    0.09998     |
|    4000     |  1180 seconds  |   10040    |    0.1999      |