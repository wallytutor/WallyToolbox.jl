# CALPHAD: site-fractions in 3 sublattice phase

In this notebook we show that a 3 sublattice phase with 2 components in a binary system introduces a new variable to the optimization, *i.e.* minimization of Gibbs energy, of the system.

Assume a phase such as $\gamma-AlMg$ with a model $(Mg)_{5}(Mg,Al)_{12}(Al,Mg)_{12}$. For simplicity in what follows we denote it as $(A)_{5}(A,B)_{12}(B,A)_{12}$.

The calculations are done under the framework of `Symbolics.jl`.

```julia
using Symbolics: @variables
using Symbolics: substitute, simplify
using Symbolics: solve_for
```

In terms of composition, such a binary system is defined by a single molar fraction of, say, component $A$, $x_A$, the amount of $x_B$ determined by balance:

```julia
@variables x_A

x_B = 1 - x_A

x_A, x_B
```

Since in the first sublattice only element $A$ is present, it has  unit site fraction. Just to keep formal we introduce symbols for the site fractions in this first sublattice.

```julia
y_A1 = 1
y_B1 = 1 - y_A1

y_A1, y_B1
```

The remaining unknowns are the site fractions in sublattice 2 and 3. Again, the sum of fractions is unit and a single value per sublattice completely defines the system:

```julia
@variables y_A2 y_A3

y_B2 = 1 - y_A2
y_B3 = 1 - y_A3

y_A2, y_B2, y_A3, y_B3
```

The site fraction being defined as the occupancy of a given sublattice $k$ with $N_s$ sites by the element in question, say $y_{A}^{(k)} = N_{a} / N_{s}$, then the number of moles $N_{a} = y_{A}^{(k)} N_{s}$. The mole fraction $x_{A}$ is then $\sum N_{A}/N_{t}$, with $N_{t}=\sum N_{s}$, the number of sites in the phase. For the phase in question $N_{t}=29$ and the mole fraction balances for both elements can be written as:

```julia
expr1 = 29 * x_A - (5 * y_A1 + 12 * y_A2 + 12 * y_A3)
expr2 = 29 * x_B - (5 * y_B1 + 12 * y_B2 + 12 * y_B3)
nothing; #hide
```

```julia
expr1
```

```julia
expr2
```

From the constraints previously introduced, these expressions obviously add up to zero. We have nonetheless the constraint of $y_{A}^{(3)}$ in terms of $y_{A}^{(2)}$

```julia
y_A3_expr = solve_for(expr2, y_A3)
```

Which can be replaced in first expression and show the indeterminacy of the system:

```julia
mapping = Dict([y_A3 => y_A3_expr])

simplify(substitute(expr1, mapping); expand=true)
```
