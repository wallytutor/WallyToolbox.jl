# DryToolingSimulation

```@meta
CurrentModule = DryToolingSimulation
DocTestSetup  = quote
    using DryToolingSimulation
end
```

!!! danger
    
    This module is *fragile* and breaking changes are still expected. It is not until all the main solvers are migrated that it will become stable. This is necessary for ensuring compatibility with all models.

## Iterative solver

The core of the iterative time-stepping solver is `step!`. This function that is described below works according to the following solution logic:

1. The `fouter!` update function is called once. This is generall where one implements the right-hand side update of the problem before stepping.

2. An initial update with `finner!` is done. Normally this is responsible by the update of matrix coefficients that are dependent on solution state.

3. If relaxation `α <= 0.0`, then the problem is treated as linear.

4. Otherwise a maximum of `M` iterations are repeated, where `fsolve!` is used to solve the problem (ofter an under-relaxation step) and is also expected to keep track of residuals.

5. Problem coefficients are updated with `finner!` if not converged.

```@docs
DryToolingSimulation.step!
```

The outer iteration for advancing between steps is carried out by `advance!`.

```@docs
DryToolingSimulation.advance!
```

Any model willing to implement its solution through the methods provided in this module is expected to explicity import and override the behaviour of the following methods for its own type:

```@docs
DryToolingSimulation.fouter!
DryToolingSimulation.finner!
DryToolingSimulation.fsolve!
DryToolingSimulation.timepoints
```

## Linear algebra

```@docs
DryToolingSimulation.TridiagonalProblem
DryToolingSimulation.solve!(::DryToolingSimulation.TridiagonalProblem)
DryToolingSimulation.change
DryToolingSimulation.residual
```

## Residuals tracking

```@docs
DryToolingSimulation.TimeSteppingSimulationResiduals
DryToolingSimulation.finaliterationdata
DryToolingSimulation.addresidual!
DryToolingSimulation.plotsimulationresiduals
```

The residuals tracking functionalities of module `DryToolingSimulation` are not often imported by the end-user (except for its plotting utility function). In this tutorial we illustrate the logic of using a residual tracker in a new solver.

```@example
using DryToolingSimulation

N = 2      # Number of variables.
M = 5      # Maximum inner steps.
steps = 10 # Time-advancement steps.

# Create a TimeSteppingSimulationResiduals object with the number of variables
# to track, how many inner iterations per step are expected, and the
# number of steps.
#
# IMPORTANT: If the total number of iterations is exceeded, it is up
# to the user to allocate more memory, the tracker will not manage it!
r = TimeSteppingSimulationResiduals(N, M, steps)

# The following loop represents a *dummy solver*. The outer loop
# provides the time-advancement while the inner loop handles the
# nonlinear problem. In the inner loop we use a random number
# generator to provide varying number of steps per outer step.
for kouter in 1:steps
    for kinner in 1:rand(2:M)
        # Keep track of inner iterations per step.
        r.innersteps[kouter] = kinner

        # Feed residuals to the solver.
        addresidual!(r, rand(r.N))
    end
end

# After running a simulation we create a new object using another
# constructor that accepts a `TimeSteppingSimulationResiduals` object. This
# handles the post-processing.
s = TimeSteppingSimulationResiduals(r)

# The new object is ready for visualization. Check the documentation
# of the following function for more details. It provides a raw figure
# and handles for modifying it for proper display.
fig = plotsimulationresiduals(s; showinner = true)[1]
```
