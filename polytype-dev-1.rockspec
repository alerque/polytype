rockspec_format = "3.0"
package = "polytype"
version = "dev-1"

source = {
   url = "git+https://github.com/alerque/polytype.git",
   branch = "master",
}

description = {
   summary = "A Rosetta stone for modern typesetting engines.",
   detailed = [[This project's goal is to provide a chrestomathy for typesetting similar to what Rosetta Code does for programming languages. The samples here are designed to compare and/or contrast the approaches taken to various typesetting situations by different typesetting engines.]],
   license = "CC0-1.0",
   homepage = "https://github.com/alerque/polytype",
   issues_url = "https://github.com/alerque/polytype/issues",
   maintainer = "Caleb Maclennan <caleb@alerque.com>",
   labels = { "typesetting" },
}

dependencies = {
   "lua >= 5.1",
   "decasify.sile == 0.9.1-1",
   "textsubsuper.sile == 1.2.0-1",
}

build = {
   type = "builtin",
   modules = {},
}
