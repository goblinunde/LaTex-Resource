# Makefile to generate pdfs from tikz pictures

TEX := xelatex
RM := rm -f
TARGETS := $(patsubst %.tex,%.pdf,$(wildcard *.tex))
TARGETS += $(patsubst %.eps,%.pdf,$(wildcard *.eps))

.PHONY: clean

all: $(TARGETS) ../plots.tex

%.pdf: %.tex
	$(TEX) $(basename $<)

%.pdf: %.eps
	epstopdf $<

clean:
	$(RM) *.pdf
	$(RM) *.aux
	$(RM) *.log
