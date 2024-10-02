```julia
using Logging
using WallyToolbox

Logging.disable_logging(Logging.Warn);
```

```julia
begin
    ###############
    ## Geometry
    ###############
    
    # Kiln length [m]
    L = 1.5
    
    # Kiln diameter [m]
    D = 0.2
    
    # Kiln slope [°]
    β = 1.0
    
    ###############
    ## Material
    ###############
    
    # Repose angle [°]
    γ = 35.0
    
    # Particle/dam size [mm]
    d = 0.1
    
    # Random packed density [kg/m³]
    ρ = 1000.0

    ###############
    # Process
    ###############

    # Feed rate [kg/h]
    ṁ = 1.0
    
    # Rotation rate [rev/min]
    ω = 2.0

    bed = RotaryKilnBedSolution(;
        model = SymbolicLinearKramersModel(),
        L = L,
        R = D / 2.0,
        Φ = ṁ / (3600ρ),
        ω = ω / 60.0,
        β = deg2rad(β),
        γ = deg2rad(γ),
        d = d / 1000.0,
    )
    plotlinearkramersmodel(bed, normz = false, normh = false)
end
```

```julia

```
