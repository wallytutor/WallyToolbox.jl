##############################################################################
# OPERATIONS
##############################################################################

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

##############################################################################
# EOF
##############################################################################