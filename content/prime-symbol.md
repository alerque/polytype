+++
title = "The Prime Symbol"
description = "In math mode, prime-time is always a good time."
extra.typesetters = [ "typst", "sile", "xelatex", "groff" ]
extra.typesetter_args = { groff = "-e -P-pA7" }
+++

Assorted ways of entering and rendering the troublesome prime symbol.

One issue is in math mode.
A typesetter has to account for how different fonts position their prime symbols.

Another problem crops up in text where quotes marks get used for things like feet and inch units in lengths or minute and second units in lattitude and longitude cordinates.
It should be possible to *not* trigger smart quotes in these cases.
