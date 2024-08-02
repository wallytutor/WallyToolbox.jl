# Kilnerys

Rotary kiln simulation tools.

## To-Do list for model

- [x] Make solid walls thickness position dependent to be able to simulate coating properly.

- [x] Make solids thermal conductivities f(z, T) and wrap internally as g(f(self._z, T)) for being able to model *high conductivity* coating. This is required because zero-thickness is not allowed under the current implementation (would require a higher branching complexity).

- [x] Generalize Kramers' model for variable internal section kiln (at least numerically).

- [ ] Provide alternative radiation properties model based on WSGG approach.

- [ ] Use perimeter weighted mean of wall and bed temperatures as wall temperature in call to radiation properties model.

- [ ] Validate Tscheng's implementation. Right now it seems that CWB coefficient is too high and bed temperature equilibrates with walls. The inverse is valid for CGW, which appears to be lower than intuitively expected. What is problematic here is that shell temperature is fine, but it could also be fine if solid was cooler and coating walls warmer by enhancing CGW and reducing CWB.

- [ ] Check Martins (2001) from Mujumdar's thesis for more details about Tscheng's model.

- [ ] Ensure local equivalent diameter is provided to Tscheng's model for generality.

- [ ] Document Tcheng's class implementation.

- [x] Document keyword arguments from different initialization methods. Partially done but requires review once inputs are made functions.

- [ ] Inverse order of solving in rotary kiln simulation algorithm. Currently it starts with a very poor gas-solid temperature gradient and that could probably be improved with previous gas phase integration.

- [ ] Implement improvement patience and minimum progress for early stop in solver convergence test method.

- [ ] Add error/progress based control to activation of radiation equation instead of constant steps.

- [ ] Implement species equations in bed model and add corresponding additional terms to heat equation.

- [ ] Add bed-wall perimeter to bed section properties getter function.

- [ ] Find k-epsilon ratio from CFD once real burner geometry is available.

- [ ] Add radiation properties to results table.

- [ ] Add kinetic law of water evaporation / organics pyrolysis. Probably this would be easier if a single fluid model (bed and gas in same set of equations) was implemented.

- [ ] Rename discharge height to dam height.

- [ ] Compare bed energy balance to its enthalpy change.

- [ ] Compute relative contribution of different modes to bed energy balance.

- [ ] Numerical evaluate bed transport regime.

- [ ] Add progress bar and logger do application.
