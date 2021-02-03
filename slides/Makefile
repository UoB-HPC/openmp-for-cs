
all: hpc-openmp-2020.pdf

%.pdf:%.tex preamble.tex
	latexmk -pdf -shell-escape $<

.PHONY: clean
clean:
	latexmk -C
	rm -f *.nav *.snm *.vrb
	rm -rf _minted*/

