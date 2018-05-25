
all: 01-intro.pdf 02-pi.pdf 03-opt.pdf 04-hybrid.pdf

%.pdf:%.tex preamble.tex
	latexmk -pdf -shell-escape $<

