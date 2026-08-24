#set page(
  paper: "a6",
)
#set par(
  justify: true,
)

#import "@preview/droplet:0.3.1": dropcap

#dropcap(
  justify: true,
  hanging-indent: 0pt,
)[
  This paragraph has a pretty plain initial or drop cap.
  It uses the default document font.
  You didn't really expect more detail with such a generic font choice, right?
  This may be exactly what you want, especially with modern typesetting styles which tend towards the minimalist.
]

#dropcap(
  justify: true,
  hanging-indent: 0pt,
  top-edge: "cap-height",
)[
  #place(dx: -0.4em, sym.quote.l)N
][
  #smallcaps[ever say never,]#sym.quote.r the saying goes.
  Someday your dropcap may include leading punctuation _and_ a hanging indent.
  No worries.
  All you have to do is guess and fudge.
]

#dropcap(
  height: 3,
  justify: true,
)[
  Another paragraph shows off a different line count.
  Note the droplet package supports a stand-off effect, but the feature has been broken for some time.
  Until this is fixed upstream, there is not a good way to demonstrate an effect comprable to other engines in Typst.
]
