module DryToolingKinetics

using DryToolingCore: AbstractKineticsMechanism
using DryToolingCore: GAS_CONSTANT
using ModelingToolkit
using Symbolics
using Symbolics: scalarize

export Graf2007AcetyleneKinetics
export unknowns
export params

struct Graf2007AcetyleneKinetics <: AbstractKineticsMechanism
    "Symbolic independent variable."
    t::Num

    "Symbolic gas pressure"
    P::Num

    "Symbolic gas temperature"
    T::Num

    "Symbolic mass fractions array"
    Y::Symbolics.Arr{Num, 1}

    "Symbolic problem right-hand side"
    RHS::Symbolics.Arr{Num, 1}

    "Symbolic rate constants"
    k::Vector{Num}

    "Symbolic reaction rates"
    r::Vector{Num}

    "Symbolic rates of progress"
    ω::Vector{Num}

    "Matrix of stoichiometric coefficients"
    ν::Matrix{Int64}

    "Array of species molecular masses"
    W::Vector{Float64}

    "Array of species names"
    names::Vector{String}

    function Graf2007AcetyleneKinetics()
        # TODO move data to external file!
    
        # Create symbolics.
        @parameters T P
        @variables t (Y(t))[1:8]
        @variables (RHS(t))[1:8]

        # Molecular masses of mechanism species.
        W = [
            0.026037999
            0.002016000
            0.028054000
            0.016042999
            0.052075999
            0.078114000
            0.012010999
            0.028014000
        ]

        names = [
            "C2H2"
            "H2"
            "C2H4"
            "CH4"
            "C4H4"
            "C6H6"
            "Cs"
            "N2"
        ]

        # Species concentration χ = ρ * Yₖ / Wₖ.
        # M = meanmolecularmass(Y, W)
        M = 1 / sum(Y ./ W)
        χ = @. (P * M / (GAS_CONSTANT * T)) * abs(Y / W)

        # Reactions coefficients.
        ν = [
            -1  1 -1  1 -1 -2  2 -1  0
            -1  1 -3  3  1  0  0  0  3
             1 -1  0  0  0  0  0  0  0
             0  0  2 -2  0  0  0  0  0
             0  0  0  0  0  1 -1 -1  0
             0  0  0  0  0  0  0  1 -1
             0  0  0  0  2  0  0  0  6
             0  0  0  0  0  0  0  0  0
        ]

        # Rate constants.
        k = [
            4.4e+03 * exp(-1.0300e+05 / (GAS_CONSTANT * T))
            3.8e+07 * exp(-2.0000e+05 / (GAS_CONSTANT * T))
            1.4e+05 * exp(-1.5000e+05 / (GAS_CONSTANT * T))
            8.6e+06 * exp(-1.9500e+05 / (GAS_CONSTANT * T))
            5.5e+06 * exp(-1.6500e+05 / (GAS_CONSTANT * T))
            1.2e+05 * exp(-1.2070e+05 / (GAS_CONSTANT * T))
            1.0e+15 * exp(-3.3520e+05 / (GAS_CONSTANT * T))
            1.8e+03 * exp(-6.4500e+04 / (GAS_CONSTANT * T))
            1.0e+03 * exp(-7.5000e+04 / (GAS_CONSTANT * T))
        ]

        # Reaction rates in molar units.
        r = k .* [
            χ[1] * χ[2]^0.36
            χ[3]^0.50
            χ[1]^0.35 * χ[2]^0.22
            χ[4]^0.21
            χ[1]^1.90 / (1.0 + 18.0*χ[2])
            χ[1]^1.60
            χ[5]^0.75
            χ[1]^1.30 * χ[5]^0.60
            χ[6]^0.75 / (1.0 + 22.0*χ[2])
        ]

        # Species production rates in molar units.
        ω = scalarize(ν * r)

        return new(t, P, T, Y, RHS, k, r, ω, ν, W, names)
    end 
end

function unknowns(::AbstractKineticsMechanism)
    @error "An specialization of this method is expexted!"
end

function params(::AbstractKineticsMechanism)
    @error "An specialization of this method is expexted!"
end

function unknowns(k::Graf2007AcetyleneKinetics)
    return [(k.Y)..., (k.RHS)...]
end

function params(k::Graf2007AcetyleneKinetics)
    return [k.T, k.P]
end

end # module DryToolingKinetics
