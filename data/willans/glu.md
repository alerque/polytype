---
papersize: a7 landscape
math: true
---

<style>
/* Glu's default font stack does not include math support. */
math { font-family: "Libertinus Math"; }
</style>

$$p_n = 1 + \sum_{i=1}^{2^n} \left\lfloor \left( \frac{n}{\sum_{j=1}^{i} \left\lfloor \cos^2\left( \pi \frac{(j-1)!+1}{j} \right) \right\rfloor} \right)^{1/n} \right\rfloor$$
