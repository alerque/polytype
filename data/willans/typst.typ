#set page(
  paper: "a7",
  flipped: true,
)

$
p_n = 1 + sum_(i=1)^(2^n) floor((n / (sum_(j=1)^i floor(cos^2(pi ((j - 1)! + 1) / j))))^(1/n))
$
