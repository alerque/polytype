SHELL = zsh
.SHELLFLAGS += -e

.ONESHELL:
.SECONDARY:
.SECONDEXPANSION:
.DELETE_ON_ERROR:

GIT ?= git
MAGICK ?= magick
NPM ?= npm
NPX ?= npx
SILE ?= sile
TERA ?= tera
TOMLQ ?= tomlq
TYPST ?= typst
WEASYPRINT ?= weasyprint
XELATEX ?= xelatex
XQ ?= xq
ZOLA ?= zola

TYPESETTERS = sile typst weasyprint xelatex
BASE_URL = /

WEASYPRINT_ARGS = $< $@

XELATEX_ARGS  = -interaction=batchmode -halt-on-error
XELATEX_ARGS += -jobname $*-xelatex $<

TYPST_ARGS += compile $< $@

SILE_ARGS = -o $@ $<

.PHONY: default
default: public

SAMPLES := $(notdir $(shell echo data/*(/)))
MANIFESTS := $(foreach S,$(SAMPLES),$(foreach T,$(TYPESETTERS),data/$(S)-$(T).toml))
PDFS := $(foreach S,$(SAMPLES),$(foreach T,$(TYPESETTERS),data/$(S)-$(T).pdf))
PREVIEWS := $(addsuffix .avif,$(basename $(PDFS)))

define make_manifest ?=
	cat <<- EOF > $(basename $@).toml
		src = "$<"
		demosrc = "$(notdir $(basename $@)$(suffix $<))"
		demoout = "$(notdir $@)"
		preview = "$(notdir $(basename $@)).avif"
		cmd = "$(subst $<,$(notdir $(basename $@)$(suffix $<)),$(subst $@,$(notdir $@),$1))"
	EOF
	exec $1
endef

.PHONY: all
all: $(PDFS)

node_modules:
	$(NPM) ci

%-sile.pdf %-sile.toml: %/sile.sil
	$(call make_manifest,$(SILE) $(SILE_ARGS))

%-sile.pdf %-sile.toml: %/sile.xml
	$(call make_manifest,$(SILE) $(SILE_ARGS))

%-typst.pdf %-typst.toml: %/typst.typ
	$(call make_manifest,$(TYPST) $(TYPST_ARGS))

%-weasyprint.pdf %-weasyprint.html: %/weasyprint.html
	$(call make_manifest,$(WEASYPRINT) $(WEASYPRINT_ARGS))

%-xelatex.pdf %-xelatex.toml: %/xelatex.tex
	$(call make_manifest,$(XELATEX) $(XELATEX_ARGS))

static/%.css: sass/%.scss | node_modules
	$(NPX) sass --no-source-map $<:$@
	$(NPX) postcss -u autoprefixer --no-map $@ -o $@

%.avif: %.pdf
	$(MAGICK) convert $< $@

.PHONY: static
static: $(PDFS) $(PREVIEWS) static/main.css
	install -Dm0644 -t static $(filter-out static/%,$^)
	for m in $(MANIFESTS); do
		tomlq -r '[.src, .demosrc] | @tsv' $$m | read src demosrc
		install -Dm0644 $$src static/$$demosrc
	done

.PHONY: public
public: zola

.PHONY: serve
serve: public
	zola serve

.PHONY: zola
zola: static
	$(ZOLA) build -u $(BASE_URL)

public/CNAME:
	echo polytype.dev > $@
