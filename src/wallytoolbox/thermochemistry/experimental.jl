
struct EinsteinThermo
    α::Vector{Float64}
    θ::Vector{Float64}
    c::Vector{Float64}
    molar_mass::Float64
    
    function EinsteinThermo(; α, θ, c, molar_mass)
        return new(α, θ, c, molar_mass)
    end
end

function einstein_specific_heat(T, θ)
    r = θ / T
    e = exp(r)
    f =  (e * r^2) / (e - 1)^2
    return 3GAS_CONSTANT * f
end

function einstein_specific_heat(T, α, θ)
    return α * einstein_specific_heat(T, θ)
end

function einstein_specific_heat(T, α, θ, a, b, c)
    corr = a * T + T * exp(b + c * T)
    return sum(einstein_specific_heat.(T, α, θ)) + corr
end

function specific_heat(obj::EinsteinThermo, T)
    return einstein_specific_heat(T, obj.α, obj.θ, (obj.c)...) / obj.molar_mass
end

# ```julia
# # For benchmarking, use WallyToolbox:
# using WallyToolbox
# using CairoMakie
# using Symbolics
#
# # To be able to extend `specific_heat`
# import WallyToolbox: specific_heat
#
# # Create object with Deffrenes coefficients.
# thermo_ca1o1 = EinsteinThermo(;
#     α = [1.142993, 0.62542, 0.218718],
#     θ = [369.447, 601.229, 188.291],
#     c = [0.00364916, -15.0586, 0.00304142],
#     molar_mass = molecularmass(ca1o1)
# )
#
# # Import built-in database:
# data = ThermoDatabase(; selected_compounds = ["CA1O1"])
#
# # Wrap functions for its evaluation:
# cp_eins(T)  = specific_heat(thermo_ca1o1, T)
# cp_ca1o1(T) = specific_heat(ca1o1, T)
#
# with_theme() do
#     T = LinRange(300, 2500, 50)
#
#     c1 = cp_ca1o1.(T)
#     c2 = cp_eins.(T)
#
#     f = Figure()
#     ax = Axis(f[1, 1])
#     lines!(ax, T, c1; color = :black)
#     lines!(ax, T, c2; color = :red)
#
#     ax.xlabel = "Temperature [K]"
#     ax.ylabel = "Specific heat [J/(kg.K)]"
#     ax.yticks = 750:100:1250
#
#     xlims!(ax, 0,  1600)
#     ylims!(ax, 750,  1250)
#    
#     f
# end
#
# # Declare a symbol and evaluate functions with it ;)
# @variables t
# cp_ca1o1(t)
# cp_eins(t)
# ```
