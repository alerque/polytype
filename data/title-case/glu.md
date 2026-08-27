---
papersize: a6
---

<style>
@page { margin: 1cm; }
h1 { font-size: 18pt; margin: 0; }
p { margin: 0 0 1em 0; }
</style>

```{lua}
-- Reuse decasify's locale-aware casing via its command line tool.
local function decasify(case, lang, s)
  local cmd = ("decasify -c %s -l %s '%s'"):format(case, lang, s)
  local pipe = io.popen(cmd)
  local out = pipe:read("*a")
  pipe:close()
  return (out:gsub("%s+$", ""))
end

local examples = {
  { str = "first impulse", lang = "en" },
  { str = "FIRST IMPULSE", lang = "en" },
  { str = "ilk ışıltı",    lang = "tr" },
  { str = "İLK IŞILTI",    lang = "tr" },
}

local out = {}
for _, case in ipairs({ "title", "lower", "upper", "sentence" }) do
  out[#out+1] = "# " .. decasify("title", "en", case .. "case") .. "\n"
  local lines = {}
  for _, e in ipairs(examples) do
    lines[#lines+1] = ("[%s] %s -> %s"):format(e.lang, e.str, decasify(case, e.lang, e.str))
  end
  out[#out+1] = table.concat(lines, "\\\n") .. "\n"
end
return table.concat(out, "\n")
```
