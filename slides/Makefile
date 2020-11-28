
all: 00-prelim.pdf 01-paralleldo.pdf 02-pi.pdf 03-simd-numa.pdf 05-gpu.pdf 07-wrapup.pdf 99-isambard.pdf

%.pdf:%.tex preamble.tex
	latexmk -pdf -shell-escape $<

.PHONY: clean
clean:
	latexmk -C
	rm -f *.nav *.snm *.vrb
	rm -rf _minted*/

