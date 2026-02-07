PDF=machine_learning.pdf
TEX=machine_learning.tex

.PHONY: all clean rebuild

all: $(PDF)

$(PDF): $(TEX)
	latexmk -pdf -interaction=nonstopmode -file-line-error $(TEX)

clean:
	latexmk -C $(TEX)

rebuild:
	latexmk -C $(TEX)
	latexmk -pdf -interaction=nonstopmode -file-line-error $(TEX)
