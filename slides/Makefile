
default:all

all: 00-prelim.pdf 01-intro.pdf 02-pi.pdf 03-opt.pdf 04-hybrid.pdf 05-gpu.pdf 06-tasks.pdf

ihpc: 01-ihpc.pdf

%.pdf:%.tex preamble.tex
	latexmk -pdf -shell-escape $<

.PHONY: clean
clean:
	latexmk -C
	rm -f *.nav *.snm *.vrb
	rm -rf _minted*/

