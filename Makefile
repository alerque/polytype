SHELL = zsh
.SHELLFLAGS += -fe

MAKEFLAGS += --jobs=$(shell nproc)

.ONESHELL:
.SECONDARY:
.SECONDEXPANSION:
.DELETE_ON_ERROR:

.PRECIOUS: .fonts/%

AWK ?= awk
CMP ?= cmp
CURL ?= curl
FCLIST ?= fc-list
GIT ?= git
GLU ?= glu
GROFF ?= groff
LUALATEX ?= lualatex
LUAROCKS ?= luarocks
MAGICK ?= magick
NPM ?= npm
NPX ?= npx
PAGEDJS ?= $(NPX) pagedjs-cli
QUARKDOWN ?= quarkdown
SATYSFI ?= satysfi
SED ?= sed
SILE ?= sile
SPEEDATA ?= sp
TERA ?= tera
TOMLQ ?= tomlq
TYPST ?= typst
WEASYPRINT ?= weasyprint
XELATEX ?= xelatex
XQ ?= xq
ZOLA ?= zola

BASE_URL = /

GLU_ARGS = --css all-system-fonts.css -o $@ $<
GROFF_ARGS = -T pdf $< > $@
LUALATEX_ARGS  = --interaction=batchmode --halt-on-error
LUALATEX_ARGS += --jobname=$*-lualatex $<
PAGEDJS_ARGS = -i $< -o $@
QUARKDOWN_ARGS = c --pdf --out $(@D) $<
SATYSFI_ARGS = $< -o $@
SILE_ARGS = -o $@ $<
SPEEDATA_ARGS = --dummy --layout $< --jobname $*-speedata
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

empty :=
space := $(empty) $(empty)

define make_manifest ?=
	cat <<- EOF > $(basename $@).toml
		src = "$<"
		demosrc = "$(notdir $(basename $@)$(suffix $<))"
		demoout = "$(notdir $@)"
		preview = "$(notdir $(basename $@)).avif"
		cmd = "$(subst $(space)$(space), ,$(subst --out $(@D),,$(subst $(NPX) ,,$(subst $<,$(notdir $(basename $@)$(suffix $<)),$(subst $@,$(notdir $@),$1)))))"
	EOF
	exec $1
endef

.PHONY: all
all: $(PDFS)

$(PDFS): fonts

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
	eval $$($(LOCALLUAROCKS) path)
	$(LOCALLUAROCKS) $(LUAROCKSARGS) install --only-deps $<
	touch $@

$(LUAMODLOCK): $(LUAROCKSMANIFEST) $(LUAMODSPEC)
	$(genrockslock) > $@

.PHONY: fonts
fonts: .fonts/EgyptianOpenType.ttf

# Don't let make delete intermediate dependencies we had to download
.PRECIOUS: .fonts/%

.fonts:
	[ -h .fonts ] || mkdir -p $@

.fonts/EgyptianOpenType.ttf: | .fonts
	$(CURL) -fsSL https://github.com/microsoft/font-tools/raw/main/EgyptianOpenType/font/eot.ttf -o $@
	touch $@

# Glu has no fontconfig support and resolves font families only through
# @font-face rules with explicit file paths. Coerce the fontconfig view
# of the families the glu samples use into such a map and hand it to
# every glu invocation via --css, so the samples themselves can refer
# to fonts by family name like the other engines do.
all-system-fonts.css: $(FONTCONFIG_FILE)
	$(FCLIST) --format '%{file}\t%{family[0]}\t%{weight}\t%{slant}\n' |
		sort | # this sort is a dirty hack to get OTFs listed before TTFs because Glu chokes on math tables in TTF
		$(AWK) -F'\t' ' \
			BEGIN { split("0 100 40 200 50 300 80 400 100 500 180 600 200 700 205 800 210 900", a, " "); for (i = 1; i in a; i += 2) w[a[i]] = a[i+1] } \
			!($$3 in w) { next } \
			seen[$$2 "/" $$3 "/" $$4]++ { next } \
			{ printf "@font-face {\n  font-family: \"%s\";\n  src: url(\"%s\");\n  font-weight: %s;\n  font-style: %s;\n}\n", $$2, $$1, w[$$3], ($$4 == 0 ? "normal" : "italic") }' > $@

%.pdf %.toml: TYPESETTER_ARGS = $(call get_typesetter_args,content/$(notdir $(basename $*)).md,$(notdir $(basename $<)))

%-glu.pdf %-glu.toml: %/glu.md all-system-fonts.css
	$(call make_manifest,$(GLU) $(TYPESETTER_ARGS) $(GLU_ARGS))

%-glu.pdf %-glu.toml: %/glu.html all-system-fonts.css
	$(call make_manifest,$(GLU) $(TYPESETTER_ARGS) $(GLU_ARGS))

%-glu.pdf %-glu.toml: %/glu.lua all-system-fonts.css
	$(call make_manifest,$(GLU) $(TYPESETTER_ARGS) $(GLU_ARGS))

%-groff.pdf %-groff.toml: %/groff.groff
	$(call make_manifest,$(GROFF) $(TYPESETTER_ARGS) $(GROFF_ARGS))

%-groff.pdf %-groff.toml: %/groff.ms
	$(call make_manifest,$(GROFF) -ms $(TYPESETTER_ARGS) $(GROFF_ARGS))

%-groff.pdf %-groff.toml: %/groff.mom
	$(call make_manifest,$(GROFF) -mom $(TYPESETTER_ARGS) $(GROFF_ARGS))

%-pagedjs.pdf %-pagedjs.toml: %/pagedjs.html
	$(call make_manifest,$(PAGEDJS) $(TYPESETTER_ARGS) $(PAGEDJS_ARGS))

data/title-case-pagedjs.pdf: data/decasify.js

%-quarkdown.pdf %-quarkdown.toml: %/quarkdown.qd
	$(call make_manifest,$(QUARKDOWN) $(TYPESETTER_ARGS) $(QUARKDOWN_ARGS))

%-satysfi.pdf %-saty.toml: %/satysfi.saty
	$(call make_manifest,$(SATYSFI) $(SATYSFI_ARGS))

%-sile.pdf %-sile.toml: %/sile.sil | installrocks
	$(call make_manifest,$(SILE) $(TYPESETTER_ARGS) $(SILE_ARGS))

%-sile.pdf %-sile.toml: %/sile.xml | installrocks
	$(call make_manifest,$(SILE) $(TYPESETTER_ARGS) $(SILE_ARGS))

%-speedata.pdf %-speedata.toml: %/speedata.xml
	$(call make_manifest,$(SPEEDATA) $(TYPESETTER_ARGS) $(SPEEDATA_ARGS))

%-typst.pdf %-typst.toml: %/typst.typ
	$(call make_manifest,$(TYPST) $(TYPESETTER_ARGS) $(TYPST_ARGS))

%-weasyprint.pdf %-weasyprint.html: %/weasyprint.html
	$(call make_manifest,$(WEASYPRINT) $(TYPESETTER_ARGS) $(WEASYPRINT_ARGS))

%-xelatex.pdf %-xelatex.toml: %/xelatex.tex
	$(call make_manifest,$(XELATEX) $(TYPESETTER_ARGS) $(XELATEX_ARGS))

%-lualatex.pdf %-lualatex.toml: %/lualatex.tex
	$(call make_manifest,$(LUALATEX) $(TYPESETTER_ARGS) $(LUALATEX_ARGS))

static/%.css: sass/%.scss | node_modules
	$(NPX) sass --no-source-map $<:$@
	$(NPX) postcss -u autoprefixer --no-map $@ -o $@

%.avif: %.pdf
	$(MAGICK) -density 150 $< $@

data/decasify.js: src/decasify-bundle.js
static/codemirror.js: src/codemirror.js

data/decasify.js static/codemirror.js: build.js | node_modules
	$(NPX) node $<

.PHONY: static
static: $(PDFS) $(PREVIEWS) static/main.css static/codemirror.js
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
