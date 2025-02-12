+++
title = "Superscript"
description = "Those superior characters are not as simple as they seem"
extra.typesetters = [ "sile", "xelatex", "typst" ]
+++

Superscripts are sometimes needed for numbers (e.g., in footnote calls), but also for letters (e.g., in French, for centuries, issue numbers; likewise in English —depending on authors— for centuries, etc.)

Many fonts include set of superscript characters.
Theoretically, assuming the font designers did their job well, and crafted them with the best of their art, with appropriate weight and shape, such “real” characters ought to look much better than, say, merely scaled and raised characters.
The Brill font, for example, is commendable in this respect, with fairly well-designed superscript characters.

When available, how are these superior characters to be used?
While direct Unicode input is sometimes possible, it is not practical.
Moreover, all characters are not always available via Unicode...

Modern OpenType fonts often can include superscript characters, under the `sups` feature.
When supported by the font, this could be the preferred way to access them, and the most reliable one for an extensive set of characters.

However, in his _Elements of Typographic Style_ (3rd edition, §4.3.2), Robert Bringhurst writes: “Many fonts include sets of superscript numbers, but these are not always of satisfactory size and design.
Text numerals set at a reduced size and elevated baseline are sometimes the best or only choice.”

Quite rightly, many fonts do not have perfect superscript characters.
But raising and scaling standard characters is a compromise, and it is not without its own issues.
The weight of such reduced characters may end up being too thin.

Indeed, Bringhurst goes on: “In many faces, smaller numbers in semibold look better than larger numbers of regular weight.”

Linear scaling may not be the best choice.
Look at well designed fonts: Smaller numbers are usually scaled _vertically_ to a proportion of the full height they would take at regular size.
This is also often the case for letters, albeit to a smaller amount.

Finally, would the text be set in italic, a correction may be needed to improve the superscript placement.

In conclusion, such a simple feature (in appearance) is an interesting challenge for digital typesetting systems thriving for quality.

They have various options at their disposal, but the best choice will depend on the font, the characters, and the context:
 - Using native superscript characters from the font?
 - Raising and scaling standard characters?
    - Linear scaling or assymetric scaling?
    - Weight of the raised and scaled characters?
    - Correction for italic text?

But do all typesetting systems offer the same capabilities in this respect?
And do they all use the same strategies?

(This discussion would also apply to subscripts, which are used in chemical formulas, for example, although mathematical notation may also be used in that case, and is of a different nature.)
