
all: 01-intro.pdf 02-pi.pdf

%.pdf:%.tex preamble.tex
	latexmk -pdf -shell-escape $<

