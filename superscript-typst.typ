#set page(
  paper: "a7",
  margin: 4mm,
)

#set text(
  font: "Libertinus Serif",
  size: 12pt,
)

#text(size:16pt)[ther] (not superscript)

#text(size:26pt)[Xᵗʰᵉʳ] (unicode superscript)

#text(size:26pt)[X#text(features: (sups: 1))[ther]] (font feature)

// Not yet supported at the time of writing,
// See https://github.com/typst/typst/pull/5777
#text(size:26pt)[X#super(typographic: true)[ther]] (typographic super)

#text(size:26pt)[X#super(typographic: false)[ther]] (non typographic super)

#text(
  font: "Libertinus Serif",
  style: "normal"
)[
  20ᵗʰ #smallcaps[xx]ᵉ /
  20#text(features: (sups:1))[th]
  #smallcaps[xx]#text(features: (sups:1))[e] /
  20#super(typographic: false)[th]
  #smallcaps[xx]#super(typographic: false)[e] /
  20#super(typographic: true)[th]
  #smallcaps[xx]#super(typographic: true)[e]
]

#text(
  font: "Libertinus Serif",
  style: "italic"
)[
  20ᵗʰ #smallcaps[xx]ᵉ /
  20#text(features: (sups:1))[th]
  #smallcaps[xx]#text(features: (sups:1))[e] /
  20#super(typographic: false)[th]
  #smallcaps[xx]#super(typographic: false)[e] /
  20#super(typographic: true)[th]
  #smallcaps[xx]#super(typographic: true)[e]
]

#text(
  font: "Libertinus Sans",
  style: "normal"
)[
  20ᵗʰ #smallcaps[xx]ᵉ /
  20#text(features: (sups:1))[th] #smallcaps[xx]#text(features: (sups:1))[e] /
  20#super(typographic: false)[th] #smallcaps[xx]#super(typographic: false)[e] /
  20#super(typographic: true)[th] #smallcaps[xx]#super(typographic: true)[e]
]

#text(
  font: "Libertinus Sans",
  style: "italic"
)[
  20ᵗʰ #smallcaps[xx]ᵉ /
  20#text(features: (sups:1))[th] #smallcaps[xx]#text(features: (sups:1))[e] /
  20#super(typographic: false)[th] #smallcaps[xx]#super(typographic: false)[e] /
  20#super(typographic: true)[th] #smallcaps[xx]#super(typographic: true)[e]
]
