# Makefile
#

TEX = xelatex
MKIDX = makeindex
MKGLS = makeglossaries
RM = rm -rf
MAKE = make
TARGET = nndl-ebook.pdf
STYLES = $(wildcard *.sty) $(wildcard config/*.sty)
SOURCES := $(wildcard *.tex) \
	$(wildcard chapters/*.tex) \
	$(wildcard frontmatter/*.tex) \
	$(wildcard appendix/*.tex) \
	$(wildcard supplements/*.tex) \
	$(wildcard supplements/snippets/*.tex) \
	$(wildcard config/*.tex)

IMAGEDEPS := $(wildcard images/*.tex)
IMAGEDEPS += $(wildcard images/*.png)
IMAGEDEPS += $(wildcard images/*.jpeg)
IMAGEDEPS += $(wildcard images/*.pdf)
IMAGEDEPS += $(wildcard images/*.eps)

.PHONY: all graphics ebook print

all: graphics $(TARGET)

$(TARGET): $(SOURCES) $(STYLES) $(IMAGEDEPS)
	$(TEX) $(basename $@)
	# $(MKIDX) $(basename $@)
	$(MKGLS) $(basename $@)
	$(TEX) $(basename $@)
	$(TEX) $(basename $@)

ebook:
	$(TEX) -interaction=nonstopmode nndl-ebook.tex
	$(MKGLS) nndl-ebook
	$(TEX) -interaction=nonstopmode nndl-ebook.tex

print:
	$(TEX) -jobname=nndl-ebook -interaction=nonstopmode "\\nndlprinttrue\\input{nndl-ebook.tex}"
	$(MKGLS) nndl-ebook
	$(TEX) -jobname=nndl-ebook -interaction=nonstopmode "\\nndlprinttrue\\input{nndl-ebook.tex}"

graphics:
	$(MAKE) -C images

clean:
	$(MAKE) -C images clean
	$(RM) *.pdf
	$(RM) main.pdf
	$(RM) *.aux
	$(RM) *.log
	$(RM) *.out
	$(RM) *.toc
	$(RM) *.idx
	$(RM) *.ilg
	$(RM) *.ind

cleanall: clean
	$(RM) *.gls
	$(RM) *.glo
	$(RM) *.glg
	$(RM) *.xdy
	$(RM) *.xdv
	$(RM) *.synctex(busy)
	$(RM) *.synctex.gz
