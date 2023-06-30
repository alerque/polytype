SHELL = zsh
.SHELLFLAGS += -e

.ONESHELL:
.SECONDARY:
.SECONDEXPANSION:
.DELETE_ON_ERROR:

TYPESETTERS = xelatex typst sile

# Work around Typst not supporting FONTCONFIG_FILE
# https://github.com/typst/typst/issues/100
LIBERTINUSDIR := $(shell xq -r '.fontconfig.dir[] | select(type == "string")' ${FONTCONFIG_FILE} | grep libertinus)/share/fonts/opentype

XELATEX = xelatex
XELATEX_ARGS = -interaction=batchmode -halt-on-error -jobname $(*F)-xelatex $<

TYPST = typst
TYPST_ARGS = --font-path $(LIBERTINUSDIR)
TYPST_ARGS += compile $< $@

SILE = sile
SILE_ARGS = -q -o $@ $<

.PHONY: default
default: public

SAMPLES := $(shell tomlq -r '.[][].id' data/samples.toml)
RESULTS := $(foreach E,$(SAMPLES),$(foreach T,$(TYPESETTERS),$(E)-$(T).pdf))

.PHONY: all
all: $(RESULTS)

%-xelatex.pdf: samples/%/xelatex.tex
	$(XELATEX) $(XELATEX_ARGS)

%-typst.pdf: samples/%/typst.typ
	$(TYPST) $(TYPST_ARGS)

%-sile.pdf: samples/%/sile.sil
	$(SILE) $(SILE_ARGS)

index.html: $(MAKEFILE_LIST) | $(RESULTS)
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

.PHONY: static
static: $(foreach R,$(RESULTS),$(R)) index.html
	mkdir -p $@
	cp $^ static

.PHONY: public
public: zola

.PHONY: zola
zola: static
	zola build

public/CNAME:
	echo polytype.dev > $@
