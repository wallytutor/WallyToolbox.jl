# -*- coding: utf-8 -*-
module DryFlowsheet

import Base: +
import Base: -
import Base: *
import Base: /
import DryMaterials: enthalpy

using DocStringExtensions: FIELDS
using Roots: find_zero
using Unitful: uconvert, ustrip, @u_str

using DryConstants: T_REF
using DryMaterials: AbstractMaterial
using DryMaterials: issolid, isliquid, isgas

export StreamPipeline
export MaterialStream
export EnergyStream
export TransportPipeline
export SolidsSeparator
export CooledCrushingMill
export transport_pipe
export cooled_crushing

"Array of materials to include in a stream."
struct StreamPipeline
    materials::Vector{AbstractMaterial}
end

#############################################################################
# Unit operation models
#############################################################################

""" Represents a material stream.

Attributes
----------
$(FIELDS)
"""
struct MaterialStream
    "Material mass flow rate [kg/s]."
    ṁ::Float64

    "Stream temperature [K]."
    T::Float64

    "Stream pressure [Pa]."
    P::Float64

    "Components mass fractions [-]."
    Y::Vector{Float64}

    "Materials pipeline associated to `Y`."
    pipeline::StreamPipeline
end

""" Represents an energy stream.

Attributes
----------
$(FIELDS)
"""
struct EnergyStream
    "Energy flow provided by stream [W]."
    ḣ::Float64
end

""" Represents a pipeline with heat transfer.

Models
------
1. `:TARGET_EXIT_TEMP` evaluates the heat transfer lost to environment \
  provided a target final stream temperature given by keyword argument \
  `temp_out`. Product temperature is updated through an `EnergyStream` \
  built with energy exchange computed through `exchanged_heat`, so that \
  numerical value can be slightly different from target value.
1. `:USING_GLOBAL_HTC` makes use of a global heat transfer coefficient \
  to evaluate heat flux across the pipe.

To-do's
-------
- Implement heat transfer losses through a convective heat transfer
  coefficient (HTC) computed from a suitable Nusselt number, for use
  of pipeline in *simulation* mode.

Attributes
----------
$(FIELDS)
"""
struct TransportPipeline
    "The output material stream at the end of pipeline."
    product::MaterialStream

    "The heat exchanged in pipeline [W]."
    power::EnergyStream

    function TransportPipeline(;
            product,
            model,
            verbose = true,
            kwargs...
        )
        ##########
        # INITIAL
        ##########

        Δq = 0.0
        power = EnergyStream(Δq)

        ##########
        # MODEL
        ##########

        if model == :TARGET_EXIT_TEMP
            # Compute enthalpy change with environment.
            Δq = exchanged_heat(product, kwargs[:temp_out])

            # Stream of energy to correct system temperature.
            power = EnergyStream(Δq)

            # Correct energy in both streams.
            product += power
        end

        if model == :USING_GLOBAL_HTC
            # Compute enthalpy change with environment.
            T∞ = kwargs[:temp_env]
            T₂ = kwargs[:temp_out]
            U = kwargs[:glob_htc]
            Δq = U * (T∞ - 0.5 * (T₂ + product.T))

            # Stream of energy to correct system temperature.
            power = EnergyStream(Δq)

            # Correct energy in both streams.
            product += power
        end

        ##########
        # POST
        ##########

        verbose && begin
            rounder(v) = round(v; digits = 1)
            p = rounder(ustrip(uconvert(u"kW", Δq * u"W")))
            T = rounder(ustrip(uconvert(u"°C", product.T * u"K")))

            @info """
            TransportPipeline with model $(model)

            Heat loss to environment..........: $(p) kW
            Product stream final temperature..: $(T) °C
            """
        end

        ##########
        # NEW
        ##########

        return new(product, power)
    end
end

""" Represents a solids separator with efficiency η.

To-do's
-------
- Add inverse model to automatically tune efficiency η.

Attributes
----------
$(FIELDS)
"""
struct SolidsSeparator
    "Solids separation efficiency [-]."
    η::Float64

    "The stream to be separated into solids and others."
    source::MaterialStream

    "The output solids stream."
    solids::MaterialStream

    "The output remaining stream."
    others::MaterialStream

    function SolidsSeparator(source; η = 1.0)
        # Retrieve elements kept constant.
        T, P, pipe = source.T, source.P, source.pipeline

        # Retrieve array of solids mass fractions, zeroeing other materials.
        Ys0 = map((m, Y)->issolid(m) ? Y : 0, pipe.materials, source.Y)

        # The mass flow of split solids stream corresponds to the mass flow
        # of solids multiplied by the separation efficiency of separator.
        m_sol = source.ṁ * sum(Ys0) * η

        # The mass flow of secondary stream (recirculating solids and other
        # phases) is the total nass flow minus separated solids.
        m_oth = source.ṁ - m_sol

        # Mass flow rates of each species in original flow.
        mk0 = source.ṁ * source.Y

        # For solids we multiply their total flow rate by the renormalized
        # mass fractions of individual species, balance for other stream.
        mk1 = m_sol * Ys0 ./ sum(Ys0)
        mk2 = mk0 .- mk1

        # Mass fractions are recomputed for each stream.
        Ys1 = mk1 / m_sol
        Ys2 = mk2 / m_oth

        # Create new streamsp
        solids = MaterialStream(m_sol, T, P, Ys1, pipe)
        others = MaterialStream(m_oth, T, P, Ys2, pipe)

        return new(η, source, solids, others)
    end
end

""" Represents a crushing device with cooling system.

Models
------
1. `:TARGET_COOLANT_TEMP` evaluates the heat transfer lost to coolant \
  provided a target final stream temperature given by keyword argument \
  `temp_out`. Product temperature is updated through an `EnergyStream` \
  built with energy exchange computed through `exchanged_heat`, so that \
  numerical value can be slightly different from target value.
1. `:USING_GLOBAL_HTC` makes use of a global heat transfer coefficient \
  to evaluate heat flux across the cooling stream.

Attributes
----------
$(FIELDS)
"""
struct CooledCrushingMill
    "The input meal applied to crushing process."
    rawmeal::MaterialStream

    "The output material stream at the end of product pipeline."
    product::MaterialStream

    "The output material stream at the end of cooling pipeline."
    coolant::MaterialStream

    "The power applied to the crushing process [W]"
    power::EnergyStream

    "The heat exchanged in between product and cooling pipelines [W]."
    loss::EnergyStream

    "Global heat transfer coefficient [W/K]."
    globalhtc::Union{Nothing, Float64}

    function CooledCrushingMill(;
            product,
            coolant,
            power,
            model,
            verbose = true,
            kwargs...
        )
        ##########
        # INITIAL
        ##########

        Δq = 0.0
        loss = EnergyStream(Δq)
        meal = product
        ghtc = nothing
        
        ##########
        # MODEL
        ##########

        if model == :TARGET_COOLANT_TEMP
            # Compute enthalpy change in cooling stream.
            Δq = exchanged_heat(coolant, kwargs[:temp_out])

            # Stream of energy to correct system temperature.
            loss = EnergyStream(Δq)

            # Correct energy in both streams.
            product += power - loss
            coolant += loss
        end

        if model == :USING_GLOBAL_HTC
            # Compute enthalpy change with coolant.
            T∞ = 0.5*(kwargs[:temp_out] + coolant.T)
            T₂ = 0.5*(kwargs[:temp_cru] + product.T)
            ghtc = kwargs[:glob_htc]

            # TODO add losses to environment through shell like in:
            # 10.45*(T_ext - 0.5*(kwargs[:temp_env] + coolant.T))
            
            # The value must be the absolute intake by the coolant
            # thus a minus sign in front of it.
            Δq = -ghtc * (T∞ - T₂)

            # Stream of energy to correct system temperature.
            loss = EnergyStream(Δq)

            # Correct energy in both streams.
            product += power - loss
            coolant += loss
        end

        ##########
        # POST
        ##########

        verbose && begin
            rounder(v) = round(v; digits = 1)
            Q = rounder(ustrip(uconvert(u"kW", power.ḣ * u"W")))
            p = rounder(ustrip(uconvert(u"kW", Δq * u"W")))
            T = rounder(ustrip(uconvert(u"°C", product.T * u"K")))

            @info """
            CooledCrushingMill with model $(model)

            Power applied to product stream...: $(Q) kW
            Heat extracted by cooling system..: $(p) kW
            Product stream final temperature..: $(T) °C
            """
        end

        ##########
        # NEW
        ##########

        return new(meal, product, coolant, power, loss, ghtc)
    end
end

#############################################################################
# Model options managers
#############################################################################

"Manage use of `TransportPipeline` with different models."
function transport_pipe(product, temp_out, temp_env, glob_htc)
    verbose = false

    function target_pipeline()
        return TransportPipeline(; model = :TARGET_EXIT_TEMP, verbose,
            product, temp_out)
    end

    function simul_pipeline()
        temp_out = isnothing(temp_out) ? product.T : temp_out

        pipe = TransportPipeline(; model = :USING_GLOBAL_HTC, verbose,
            product, temp_out, glob_htc, temp_env)

        temp_out = pipe.product.T
        return pipe, temp_out
    end

    pipe = isnothing(glob_htc) ? target_pipeline() : let
        pipe, temp_out = simul_pipeline()
        pipe
    end

    return pipe, temp_out
end

"Manage use of `CooledCrushingMill` with different models."
function cooled_crushing(; product, coolant, power, temp_out, temp_cru,
                           glob_htc, α = 1.0e-04)
    verbose = false

    function target_pipeline()
        return CooledCrushingMill(; model = :TARGET_COOLANT_TEMP, verbose,
            product, coolant, power, temp_out)
    end

    function simul_pipeline()
        temp_out = isnothing(temp_out) ? coolant.T : temp_out
        temp_cru = isnothing(temp_cru) ? product.T : temp_cru
        
        pipe = CooledCrushingMill(; model = :USING_GLOBAL_HTC, verbose, 
            product, coolant, power, temp_out, glob_htc, temp_cru)

        temp_out = α * pipe.coolant.T + (1-α) * temp_out
        temp_cru = α * pipe.product.T + (1-α) * temp_cru
        
        # temp_out = pipe.coolant.T
        # temp_cru = pipe.product.T
        
        return pipe, temp_out, temp_cru
    end

    pipe = isnothing(glob_htc) ? target_pipeline() : let
        pipe, temp_out, temp_cru = simul_pipeline()
        pipe
    end

    return pipe, temp_out, temp_cru
end

#############################################################################
# enthalpy()
#############################################################################

function enthalpy(pipe::StreamPipeline, T, P, Y)
    return sum(Y .* enthalpy.(pipe.materials, T, P))
end

function enthalpy(stream::MaterialStream, T, P)
    return enthalpy(stream.pipeline, T, P, stream.Y)
end

function enthalpy(stream::MaterialStream; kwargs...)
    kw = Dict(kwargs)
    T = get(kw, :T, stream.T)
    P = get(kw, :P, stream.P)
    Y = get(kw, :Y, stream.Y)
    return enthalpy(stream.pipeline, T, P, Y)
end

#############################################################################
# enthalpyflowrate()
#############################################################################

enthalpyflowrate(s::MaterialStream) = s.ṁ * enthalpy(s)

enthalpyflowrate(e::EnergyStream) = e.ḣ

@doc "Enthalpy flow rate of given stream [W]." enthalpyflowrate

#############################################################################
# Other functions
#############################################################################

"Heat exchanged with stream to match outlet temperature."
function exchanged_heat(s::MaterialStream, T_out)
    # The rate of heat leaving the system [kg/s * J/kg = W].
    ḣ_out = s.ṁ * enthalpy(s; T = T_out)

    # The change of rate across the system [W].
    return ḣ_out - enthalpyflowrate(s)
end

#############################################################################
# Overloads
#############################################################################

function Base.:+(s₁::MaterialStream, s₂::MaterialStream;
                 verbose = false, message = "")
    # Can only mix streams using same material pipeline.
    @assert s₁.pipeline == s₂.pipeline

    # Retrieve flow rates.
    ṁ₁ = s₁.ṁ
    ṁ₂ = s₂.ṁ

    # Total mass flow is the sum of stream flows.
    ṁ = ṁ₁ + ṁ₂

    # Mass weighted average pressure.
    P = (ṁ₁ * s₁.P + ṁ₂ * s₂.P) / ṁ

    # Compute species total mass flow and divide by total flow
    # rate to get resulting stream mass fractions.
    Y = (ṁ₁ * s₁.Y + ṁ₂ * s₂.Y) / ṁ

    # Energy flow is the sum of individual stream flows.
    ĥ = enthalpyflowrate(s₁) + enthalpyflowrate(s₂)

    function f(t)
        # Create a stream with other conditions fixed.
        sn = MaterialStream(ṁ, t, P, Y, s₁.pipeline)

        # Check if with temperature `t` it matches `ĥ`.
        return enthalpyflowrate(sn) - ĥ
    end

    # Find new temperature starting from the top.
    T = find_zero(f, max(s₁.T, s₂.T))

    # Create resulting stream.
    sₒ = MaterialStream(ṁ, T, P, Y, s₁.pipeline)

    verbose && begin
        rounder(v) = round(v; digits = 1)
        T1 = rounder(ustrip(uconvert(u"°C", s₁.T * u"K")))
        T2 = rounder(ustrip(uconvert(u"°C", s₂.T * u"K")))
        To = rounder(ustrip(uconvert(u"°C", sₒ.T * u"K")))

        # TODO make more informative!
        @info """
        MaterialStream addition (+) $(message)

        First stream temperature..........: $(T1) °C
        Second stream temperature.........: $(T2) °C
        Resulting stream temperature......: $(To) °C
        """
    end

    return sₒ
end

function Base.:+(s::MaterialStream, e::EnergyStream)
    # Energy flow is the sum of individual stream flows.
    ĥ = enthalpyflowrate(s) + enthalpyflowrate(e)

    function f(t)
        # Create a stream with other conditions fixed.
        sn = MaterialStream(s.ṁ, t, s.P, s.Y, s.pipeline)

        # Check if with temperature `t` it matches `ĥ`.
        return enthalpyflowrate(sn) - ĥ
    end

    # # Find new temperature starting from current temperature.
    T = find_zero(f, T_REF)

    # Create resulting stream.
    return MaterialStream(s.ṁ, T, s.P, s.Y, s.pipeline)
end

function Base.:/(s::MaterialStream, n::Number)
     MaterialStream(s.ṁ / n, s.T, s.P, s.Y, s.pipeline)
end
    
function Base.:-(e₁::EnergyStream, e₂::EnergyStream)
    return EnergyStream(e₁.ḣ - e₂.ḣ)
end

function Base.:+(e₁::EnergyStream, e₂::EnergyStream)
    return EnergyStream(e₁.ḣ + e₂.ḣ)
end

function Base.:+(p::TransportPipeline, s::MaterialStream)
    return p.product + s
end

end # (module DryFlowsheet)
