+++
title = "Title Case"
description = "Title casing prose is more complex than munging some glyphs."
extra.typesetters = [ "sile", "typst" ]
+++

Coders have it easy.
When they want to cast a variable name between cases there are a myriad of libraries for the purpose.
Writers have it harder.
Each language comes with its own challenges, and most have more than one style guide.
In the case of English, even the style guides can leave much up to interpretation.

This demo is interesting not because different typesetting engines handle this either the same or differently, but because one library can be used in more than one engine.
Specifically the [decasify](https://github.com/alerque/decasify) project implements various prose casing functions and can be used as a native package in either SILE or Typst.
