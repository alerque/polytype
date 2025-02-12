SHELL = zsh
.SHELLFLAGS += -e

MAKEFLAGS += --jobs=$(shell nproc)

.ONESHELL:
.SECONDARY:
.SECONDEXPANSION:
.DELETE_ON_ERROR:

.PRECIOUS: .fonts/%

AWK ?= awk
CMP ?= cmp
CURL ?= curl
GIT ?= git
GROFF ?= groff
LUAROCKS ?= luarocks
MAGICK ?= magick
NPM ?= npm
NPX ?= npx
PAGEDJS ?= $(NPX) pagedjs-cli
SATYSFI ?= satysfi
SED ?= sed
SILE ?= sile
TERA ?= tera
TOMLQ ?= tomlq
TYPST ?= typst
WEASYPRINT ?= weasyprint
XELATEX ?= xelatex
XQ ?= xq
ZOLA ?= zola

BASE_URL = /

GROFF_ARGS = -T pdf $< > $@
PAGEDJS_ARGS = -i $< -o $@

SATYSFI_ARGS = $< -o $@

SILE_ARGS = -o $@ $<

TYPST_ARGS = compile $< $@

WEASYPRINT_ARGS = $< $@

XELATEX_ARGS  = -interaction=batchmode -halt-on-error
XELATEX_ARGS += -jobname $*-xelatex $<

LUAROCKSARGS ?=

.PHONY: default
default: public

get_typesetters = $(shell $(SED) '0,/^\+\+\+$$/d;/^\+\+\+$$/,$$d' $1 | $(TOMLQ) -r '.extra.typesetters[]' | xargs)
get_typesetter_args = $(shell $(SED) '0,/^\+\+\+$$/d;/^\+\+\+$$/,$$d' $1 | $(TOMLQ) -r '.extra.typesetter_args.$2 // empty')

SAMPLES := $(notdir $(shell echo data/*(/)))
MANIFESTS := $(foreach S,$(SAMPLES),$(foreach T,$(call get_typesetters,content/$(S).md),data/$(S)-$(T).toml))
PDFS := $(addsuffix .pdf,$(basename $(MANIFESTS)))
PREVIEWS := $(addsuffix .avif,$(basename $(PDFS)))

define make_manifest ?=
	cat <<- EOF > $(basename $@).toml
		src = "$<"
		demosrc = "$(notdir $(basename $@)$(suffix $<))"
		demoout = "$(notdir $@)"
		preview = "$(notdir $(basename $@)).avif"
		cmd = "$(subst $(NPX) ,,$(subst $<,$(notdir $(basename $@)$(suffix $<)),$(subst $@,$(notdir $@),$1)))"
	EOF
	exec $1
endef

.PHONY: all
all: $(PDFS)

node_modules:
	$(NPM) ci

LUAMODSPEC := polytype-dev-1.rockspec
LUAMODLOCK := polytype-dev-1.rockslock

LOCALLUAROCKS := $(LUAROCKS) --tree lua_modules --lua-version 5.1
genrockslock := $(LOCALLUAROCKS) $(LUAROCKSARGS) list --porcelain | $(AWK) '{print $$1 " " $$2}'
rocksmatch := ( T=$$(mktemp); trap 'rm -f "$$T"' EXIT HUP TERM; $(genrockslock) > "$$T"; $(CMP) -s $(LUAMODLOCK) "$$T" )

LUAROCKSMANIFEST := lua_modules/lib/luarocks/rocks-5.1/manifest

.PHONY: installrocks
installrocks: $(LUAMODLOCK) $(shell $(rocksmatch) || echo $(LUAROCKSMANIFEST))

$(LUAROCKSMANIFEST): $(LUAMODSPEC) $(shell $(rocksmatch) || echo force)
	$(LOCALLUAROCKS) $(LUAROCKSARGS) install --only-deps $<
	touch $@

$(LUAMODLOCK): $(LUAROCKSMANIFEST) $(LUAMODSPEC)
	$(genrockslock) > $@

.PHONY: fonts
fonts: .fonts/EgyptianOpenType.ttf

.fonts:
	mkdir -p $@

.fonts/EgyptianOpenType.ttf: | .fonts
	$(CURL) -fsSL https://github.com/microsoft/font-tools/raw/main/EgyptianOpenType/font/eot.ttf -o $@
	touch $@

%-groff.pdf %-groff.toml: TYPESETTER_ARGS = $(call get_typesetter_args,content/$(notdir $(basename $*)).md,$(notdir $(basename $<)))

%-groff.pdf %-groff.toml: %/groff.groff
	$(call make_manifest,$(GROFF) $(TYPESETTER_ARGS) $(GROFF_ARGS))

%-groff.pdf %-groff.toml: %/groff.ms
	$(call make_manifest,$(GROFF) -ms $(TYPESETTER_ARGS) $(GROFF_ARGS))

%-groff.pdf %-groff.toml: %/groff.mom
	$(call make_manifest,$(GROFF) -mom $(TYPESETTER_ARGS) $(GROFF_ARGS))

%-pagedjs.pdf %-pagedjs.toml: %/pagedjs.html
	local args="$(call get_typesetter_args,content/$(notdir $(basename $@)).md,$(notdir $(basename $<)))"
	$(call make_manifest,$(PAGEDJS) $(TYPESETTER_ARGS)  $(PAGEDJS_ARGS))

%-satysfi.pdf %-saty.toml: %/satysfi.saty
	$(call make_manifest,$(SATYSFI) $(SATYSFI_ARGS))

%-sile.pdf %-sile.toml: %/sile.sil | installrocks
	local args="$(call get_typesetter_args,content/$(notdir $(basename $@)).md,$(notdir $(basename $<)))"
	$(call make_manifest,$(SILE) $(TYPESETTER_ARGS) $(SILE_ARGS))

%-sile.pdf %-sile.toml: %/sile.xml | installrocks
	local args="$(call get_typesetter_args,content/$(notdir $(basename $@)).md,$(notdir $(basename $<)))"
	$(call make_manifest,$(SILE) $(TYPESETTER_ARGS) $(SILE_ARGS))

%-typst.pdf %-typst.toml: %/typst.typ
	local args="$(call get_typesetter_args,content/$(notdir $(basename $@)).md,$(notdir $(basename $<)))"
	$(call make_manifest,$(TYPST) $(TYPESETTER_ARGS) $(TYPST_ARGS))

%-weasyprint.pdf %-weasyprint.html: %/weasyprint.html
	local args="$(call get_typesetter_args,content/$(notdir $(basename $@)).md,$(notdir $(basename $<)))"
	$(call make_manifest,$(WEASYPRINT) $(TYPESETTER_ARGS) $(WEASYPRINT_ARGS))

%-xelatex.pdf %-xelatex.toml: %/xelatex.tex
	local args="$(call get_typesetter_args,content/$(notdir $(basename $@)).md,$(notdir $(basename $<)))"
	$(call make_manifest,$(XELATEX) $(TYPESETTER_ARGS) $(XELATEX_ARGS))

static/%.css: sass/%.scss | node_modules
	$(NPX) sass --no-source-map $<:$@
	$(NPX) postcss -u autoprefixer --no-map $@ -o $@

%.avif: %.pdf
	$(MAGICK) convert -density 150 $< $@

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

.PHONY: force
force: ;
