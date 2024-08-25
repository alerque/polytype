#set page(
  width: auto,
  height: auto,
  margin: 0.5cm
)

#let test(font-name, ehfc)= {(
  table.cell[#font-name],
  table.cell[#set text(font: (font-name), fallback: false); 𓌃𓂧𓐰𓏏𓐱𓏯𓀁𓏪𓆎𓅓𓊖 ],
  table.cell[#set text(font: (font-name), fallback: false); 𓄤𓆑𓐰𓂋],
  table.cell[#set text(font: (font-name), fallback: false); 𓆣𓐰𓂋𓇋𓁛],
  if ehfc {
    table.cell(align: center)[✅]
  }
)}

#table(
  columns: 5,
  stroke: none,
  table.hline(stroke: 0.08em),
  table.header(
    [Font name],
    [_mdw.t-km.t_\ ‘Egyptian language’],
    [_nfr_\ ‘fine, beautiful’],
    [_ḫprj_\ ‘Khepri’],
    [Has U+13430?]
  ),
  table.hline(stroke: 0.05em),
  ..test(
    "Egyptian Text",
    true
  ),
  ..test(
    "NewGardiner",
    true
  ),
  ..test(
    "Untitled1",
    true
  ),
  ..test(
    "JSesh font",
    false
  ),
  ..test(
    "Noto Sans EgyptHiero",
    false
  ),
  table.hline(stroke: 0.08em),
)
