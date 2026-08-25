+++
title = "Title Case"
description = "Title casing prose is more complex than munging some glyphs."
weight = 4
extra.typesetters = [ "sile", "typst", "glu", "pagedjs" ]

[extra.typesetter_args]
pagedjs = "--additional-script data/decasify.js"
+++

Coders have it easy.
When they want to cast a variable name between cases there are a myriad of libraries for the purpose.
Writers have it harder.
Each language comes with its own challenges, and most have more than one style guide.
In the case of English, even the style guides can leave much up to interpretation.

This demo is interesting not because different typesetting engines handle this either the same or differently, but because one library can be used in more than one engine.
Specifically the [decasify](https://github.com/alerque/decasify) project implements various prose casing functions and can be used as a native package in either SILE or Typst, Glu uses a small wrapper function around it's command line interface, and Paged JS uses a JavaScript wrapper that makes the WASM module available to the typesetter.

This demonstrates all included engines effectively passing the content to the same casing library, with the caveat that Glu does not track the language attribute on specific text spans and pass them to the shaper. SILE, Typst, and Paged JS demonstrate the surrounding document context being maintained both into and out of the filter and hence into the final text shaping.
