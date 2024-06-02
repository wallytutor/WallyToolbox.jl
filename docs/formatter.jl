# -*- coding: utf-8 -*-

testnote = """\
```julia; @example notebook
using Printf
using Unitful

# Stefan-Boltzmann constant.
const σ = 5.67e-08u"W/(m^2*K^4)"

nothing; # hide 1
```

Some text for testing multiple captures.

```julia; @example notebook
f(x) = x^2

nothing; # hide 2
```
"""

testequation = """\
Standard equation:

\$\$
\\frac{1}{2} = \\frac{2}{4}
\$\$

And something that should not exist

\$\$ f(x) = x^2 + 1 \$\$
"""

testcitations = """"\
For instance, ([[@Masamune1963a]]) studied things, but also did
([[@Luikov1968a]]) and many others.
"""

@info """
testing documenter code blocks:
$(formatnotecells(testnote))
"""

@info """
testing multiline equations:
$(formatequations(testequation))
"""

@info """
testing multiline equations:
$(formatcitations(testcitations, "../.."))
"""
