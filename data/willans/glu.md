---
papersize: a7 landscape
math: true
---

<style>
@font-face {
  font-family: "Libertinus Serif";
  src: url("../../.fonts/LibertinusSerif-Regular.otf");
}
@font-face {
  font-family: "Libertinus Math";
  src: url("../../.fonts/LibertinusMath-Regular.otf");
}
body { font-family: "Libertinus Serif"; }
math { font-family: "Libertinus Math"; font-size: 11pt; }
</style>

$$p_n = 1 + \sum_{i=1}^{2^n} \left\lfloor \left( \frac{n}{\sum_{j=1}^{i} \left\lfloor \cos^2\left( \pi \frac{(j-1)!+1}{j} \right) \right\rfloor} \right)^{1/n} \right\rfloor$$
