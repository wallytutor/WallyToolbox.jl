##############################################################################
# METHODS
##############################################################################

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

##############################################################################
# EOF
##############################################################################