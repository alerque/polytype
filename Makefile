SHELL = zsh
.SHELLFLAGS += -e

.ONESHELL:
.SECONDARY:
.SECONDEXPANSION:
.DELETE_ON_ERROR:

EXPERIMENTS = integral
TYPESETTERS = latex typst sile

LATEX = xelatex
LATEX_ARGS = -interaction=batchmode -halt-on-error -jobname $(*F)-latex $<

TYPST = typst
TYPST_ARGS = compile $< $@

SILE = sile
SILE_ARGS = -q -o $@ $<

.PHONY: default
default: all

.PHONY: all
all: $(foreach E,$(EXPERIMENTS),$(foreach T,$(TYPESETTERS),$(E)-$(T).pdf))

%-latex.pdf: %.tex
	$(LATEX) $(LATEX_ARGS)

%-typst.pdf: %.typ
	$(TYPST) $(TYPST_ARGS)

%-sile.pdf: %.sil
	$(SILE) $(SILE_ARGS)
