# Rotary Kiln

General rotary kiln simulation utilities in Rust.

## Roadmap

### General implementations

- [ ] Implement all elements as in Cantera database.
- [ ] Implement the full Gri-Mech 3.0 mechanism species.
- [ ] Provide calculation of thermodynamic properties.
- [ ] Provide calculation of transport properties.
- [ ] Provide calculation of 1- or 2-step combustion outputs.
- [ ] Provide ideal gas mixture properties models.
- [ ] Implement reactor network model with mass and energy balances.
- [ ] Implement wall model with multilayer for reactors.
- [ ] Implement drum transport model for bed flow rate.
- [ ] Couple reactor model with heating of drum bed.
- [ ] Implement industrial to SI unit conversion.

### Advanced goals

- [ ] Include built-in stiff ODE integration.
- [ ] Include built-in non-linear optimization.
- [ ] Implement detailed chemical kinetics for combustion.
- [ ] Implement gas phase equilibrium calculation.
- [ ] Implement CALPHAD equilibrium for condensate phases.
- [ ] Allow parallel/serial connection of reactor layers.
- [ ] Generalize drum transport model with lifters effect.

### Support roles

- [ ] Implement `Display` and `Debug` traits to all structs.
- [ ] Provide plotting of thermal and composition profiles.
- [ ] Organize thermodynamic data (elements/species) in hash-maps.
- [ ] Convert polynomial data to be compatible with Horner format.
