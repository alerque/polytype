SHELL = zsh
.SHELLFLAGS += -e

.ONESHELL:
.SECONDARY:
.SECONDEXPANSION:
.DELETE_ON_ERROR:

GIT = git
SILE = sile
TERA = tera
TOMLQ = tomlq
TYPST = typst
XELATEX = xelatex
XQ = xq
ZOLA = zola

TYPESETTERS = xelatex typst sile

# Work around Typst not supporting FONTCONFIG_FILE
# https://github.com/typst/typst/issues/100
ifneq ($(FONTCONFIG_FILE),)
LIBERTINUSDIR := $(shell $(XQ) -r '.fontconfig.dir[] | select(type == "string")' ${FONTCONFIG_FILE} | grep libertinus)/share/fonts/opentype
TYPST_ARGS += --font-path $(LIBERTINUSDIR)
else
TYPST_ARGS =
endif

XELATEX_ARGS  = -interaction=batchmode -halt-on-error
XELATEX_ARGS += -jobname $*-xelatex $<

TYPST_ARGS += compile $< $@

SILE_ARGS = -o $@ $<

.PHONY: default
default: public

SAMPLES := $(basename $(notdir $(shell $(GIT) ls-files 'content/*.md' | xargs grep '^typesetters =' -l)))
RESULTS := $(foreach S,$(SAMPLES),$(foreach T,$(TYPESETTERS),content/$(S)-$(T).pdf))

.PHONY: all
all: $(RESULTS)

%-xelatex.pdf: %/xelatex.tex
	$(XELATEX) $(XELATEX_ARGS)

%-typst.pdf: %/typst.typ
	$(TYPST) $(TYPST_ARGS)

%-sile.pdf: %/sile.sil
	$(SILE) $(SILE_ARGS)

%-sile.pdf: %/sile.xml
	$(SILE) $(SILE_ARGS)

.PHONY: static
static: $(foreach R,$(RESULTS),$(R))
	mkdir -p $@
	cp $^ static

.PHONY: public
public: zola

.PHONY: zola
zola: static
	$(ZOLA) build

public/CNAME:
	echo polytype.dev > $@
