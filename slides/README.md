# Slides

Source code for the teaching material (slides) that teach the OpenMP for Computational Scientists course.
The course material is presented using Fortran.

## Course structure

1. OpenMP overview: shared memory and parallel do.
2. Data sharing clauses and reductions.
3. Vectorisation and code optimisaion.
4. NUMA and Hybrid MPI+OpenMP.
5. OpenMP for GPUs.
6. Tasks and Tools.

## Compilation
The slides are written in Latex.
You should be able to build all the slides simply by typing ```make```.

### Dependancies
The LaTeX uses the following packages:
- beamer
- amsmath
- pgfplots
- minted
- fontenc
- multicol
- booktabs
- adjustbox

