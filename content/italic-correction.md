+++
title = "Automated Italic Correction"
description = "Switching between italic and roman, and reciprocally"
extra.typesetters = [ "sile", "xelatex", "typst" ]
+++

When an italicized word is followed or preceded by non-italicized text, the spacing may need to be adjusted, or “corrected”, so that the characters do not overlap.

You might thus want to insert some additional space between italicized words and non-italicized ones.
But inserting the necessary spaces manually is quite tedious, not to say impractical... And which type of space should you use?

An automated solution would be needed.
However, the concept of italic correction does not exist in OpenType fonts, and they do not provide the metrics that would allow a typesetting system to implement it easily. (This would apply to Graphite fonts too. More generally, there is no known font format supporting kerning across font style changes. Well, some TeX fonts have such a possibility, but it does not really help here with OpenType _in general._)

So eventually, it boils down to the typesetting system to implement a heuristic solution...

A possible heuristic approach is to use the difference between a glyph’s bounding box and its advance width (when switching from italics to roman) or its bearing width (the other way round, often less critical, but still adequate).
Assuming italics is slanted forward (in left-to-right writing direction) and that italicized glyphs usually reach their maximum extent to the right towards their top (and towards their bottom, on their left side), then it is possible to approximate a fairly decent correction.

Nevertheless, this solution cannot be made perfect, even assuming a reasonable choice of fonts.
Pathological cases may still occur, even in latin scripts, for which there is no solution but using manual kerning.

Different typesetting systems may implement this heuristic in different ways, and your mileage may vary.
