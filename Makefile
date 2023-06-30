SHELL = zsh
.SHELLFLAGS += -e

.ONESHELL:
.SECONDARY:
.SECONDEXPANSION:
.DELETE_ON_ERROR:

TYPESETTERS = latex typst sile

LATEX = xelatex
LATEX_ARGS = -interaction=batchmode -halt-on-error -jobname $(*F)-latex $<

TYPST = typst
TYPST_ARGS = compile $< $@

SILE = sile
SILE_ARGS = -q -o $@ $<

.PHONY: default
default: all

EXPERIMENTS = integral
RESULTS := $(foreach E,$(EXPERIMENTS),$(foreach T,$(TYPESETTERS),$(E)-$(T).pdf))

.PHONY: all
all: $(RESULTS)

%-latex.pdf: %.tex
	$(LATEX) $(LATEX_ARGS)

%-typst.pdf: %.typ
	$(TYPST) $(TYPST_ARGS)

%-sile.pdf: %.sil
	$(SILE) $(SILE_ARGS)

public/index.html: $(MAKEFILE_LIST) | $(RESULTS)
	mkdir -p $(@D)
	cat <<- EOF > $@
		<!DOCTYPE html>
			<head>Polytypes</head>
			<body>
				<ul>
					$(foreach R,$(RESULTS),
					<li><a href="$(R)">$(R)</a></li>)
				</ul>
			</body>
		</html>
	EOF

public: public/index.html $(RESULTS)
	cp $(RESULTS) $@

