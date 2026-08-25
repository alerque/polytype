#set page(
  paper: "a6",
)
#set par(
  first-line-indent: 0pt,
  justify: false,
)
#set text(
  font: "Libertinus Serif",
  size: 16pt,
)

#let egyp-sample(phonetics, translation, str) = {
  (
    [
      #set text(lang: "und");_#(phonetics)_
      #set text(lang: "en");‘#translation’
      #v(-0.5em)
      #line(length: 100%)
      #v(-1em)
      #set text(lang: "egy", font: "Egyptian Text", size: 1.5em, fallback: false);#str
    ]
  )
}

#egyp-sample("mdw.t-km.t", "Egyptian language", "𓌃𓂧𓐰𓏏𓐱𓏯𓀁𓏪𓆎𓅓𓊖")

#egyp-sample("nfr", "fine, beautiful", "𓄤𓆑𓐰𓂋")

#egyp-sample("ḫprj", "Khepri", "𓆣𓐰𓂋𓇋𓁛")
