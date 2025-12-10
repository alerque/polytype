// 2025, Didier Willis
// License: MIT.
// Typst does not have these extended limits out of the box:
//   projlim, injlim, varprojlim, varinjlim,
//   varlimsup, varliminf.
// So here is a possible implementation...
// Total newbie, so it's maybe not idiomatic
#let varlim(arrow) = context {
  let lim = "lim"
  let lim-width = measure(lim).width
  let arrow-height = measure(arrow).height
  let varlimop = box(
    width: lim-width,
    baseline: arrow-height,
    box(
      width: 0pt,
      baseline: arrow-height,
      [#math.stretch(arrow, size: lim-width)]
    )
    +
    box(
      baseline: 0pt,
      width: 0pt,
      lim
    )
  )
  return varlimop
}
// Helpers
#let strut = context {
  // Weird way to do a small adjustment for varliminf
  // so that the limit expression is a bit lower
  block(height: measure("").height, width: 0pt)
}
#let varprojlim = math.limits(varlim(sym.arrow.l), inline:false)
#let projlim = math.limits("proj\u{2009}lim", inline: false)
#let varinjlim = math.limits(varlim(sym.arrow.r), inline:false)
#let injlim = math.limits("inj\u{2009}lim", inline: false)
#let varliminf = math.limits(underline("lim"+strut), inline: false)
#let varlimsup = math.limits(overline("lim"), inline: false)

// --- Now the intended document ---

#set page(
  paper: "a7",
  margin: 4mm,
)
#set text(
  font: "Libertinus Serif",
  size: 12pt,
)

$ projlim_(i in I) A_i = varprojlim_(i in I) A_i $
Inline: $projlim_(i in I) A_i = varprojlim_(i in I) A_i$

$ injlim_(i in I) A_i = varinjlim_(i in I) A_i $
Inline: $injlim_(i in I) A_i = varinjlim_(i in I) A_i$

$ limsup_(n -> oo) a_n = varlimsup_(n -> oo) a_n $

Inline: $limsup_(n -> oo) a_n = varlimsup_(n -> oo) a_n$

$ liminf_(n -> oo) a_n = varliminf_(n -> oo) a_n $

Inline: $liminf_(n -> oo) a_n = varliminf_(n -> oo) a_n$
