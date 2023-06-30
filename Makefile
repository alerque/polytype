EXPERIMENTS = integral

.PHONY: all
all: $(foreach E,$(EXPERIMENTS),$(E)-latex.pdf $(E)-typst.pdf $(E)-sile.pdf)

%-latex.pdf: %.tex
	xelatex -jobname $(*F)-latex $<

%-typst.pdf: %.typ
	typst compile $< $@

%-sile.pdf: %.sil
	sile -o $@ $<

.PHONY: watch
watch:
	git ls-files | entr -c make
