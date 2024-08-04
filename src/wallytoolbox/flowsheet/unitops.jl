##############################################################################
# UNITOPS
##############################################################################

export StreamPipeline
export MaterialStream
export EnergyStream
export TransportPipeline
export SolidsSeparator
export CooledCrushingMill

#############################################################################
# Pipeline
#############################################################################

"Array of materials to include in a stream."
struct StreamPipeline
    materials::Vector{AbstractMaterial}
end

#############################################################################
# Unit operation models
#############################################################################

""" Represents a material stream.

## Fields

$(TYPEDFIELDS)
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

## Fields

$(TYPEDFIELDS)
"""
struct EnergyStream
    "Energy flow provided by stream [W]."
    ḣ::Float64
end

""" Represents a pipeline with heat transfer.

## Models

1. `:TARGET_EXIT_TEMP` evaluates the heat transfer lost to environment \
  provided a target final stream temperature given by keyword argument \
  `temp_out`. Product temperature is updated through an `EnergyStream` \
  built with energy exchange computed through `exchanged_heat`, so that \
  numerical value can be slightly different from target value.
1. `:USING_GLOBAL_HTC` makes use of a global heat transfer coefficient \
  to evaluate heat flux across the pipe.

## To-do

- Implement heat transfer losses through a convective heat transfer
  coefficient (HTC) computed from a suitable Nusselt number, for use
  of pipeline in *simulation* mode.

## Fields

$(TYPEDFIELDS)
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

## To-do

- Add inverse model to automatically tune efficiency η.

## Fields

$(TYPEDFIELDS)
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

## Models

1. `:TARGET_COOLANT_TEMP` evaluates the heat transfer lost to coolant \
  provided a target final stream temperature given by keyword argument \
  `temp_out`. Product temperature is updated through an `EnergyStream` \
  built with energy exchange computed through `exchanged_heat`, so that \
  numerical value can be slightly different from target value.
1. `:USING_GLOBAL_HTC` makes use of a global heat transfer coefficient \
  to evaluate heat flux across the cooling stream.

## Fields

$(TYPEDFIELDS)
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


end

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

    return CooledCrushingMill(meal, product, coolant, power, loss, ghtc)
end

##############################################################################
# EOF
##############################################################################