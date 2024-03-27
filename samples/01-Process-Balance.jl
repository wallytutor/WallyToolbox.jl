### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ aa8086be-ec51-11ee-2ca0-933674507b58
begin
	@info "Loading packages..."
	push!(LOAD_PATH, joinpath(@__DIR__, ".."))
	using WallyToolbox

	import Unitful
	
	using Luxor
	using Roots: find_zero
	using Statistics: mean
	using SteamTables: SpecificH
	using Unitful: @u_str, uconvert, ustrip
	
	using DocStringExtensions: FIELDS
	using DryUtilities: nm3_h_to_kg_h, kg_h_to_nm3_h
	using DryMaterials: AbstractLiquidMaterial
	using DryMaterials: PureWater, PureAir, PureMineral
	using DryMaterials: density
	using DryFlowsheet
end

# ╔═╡ 85be503e-eedf-49b4-952b-f581e71249ba
""" Process `CooledCrusherModel` inputs in SI units.

Parameters are the same as the attributes. The next are optional key-words.
Operating pressure `P_env` defaults to atmospheric pressure. If `T_in_cool`
is not provided, it is set to `T_env`. To compute cooling efficiency it is
recommended to provide the measured `T_out_cool` to get a precise balance.
Other values `T_in_sep` and `T_out_rec` are used for better balance.

Attributes
----------
$(FIELDS)
"""
struct CooledCrusherInputs
    "Environment temperature."
    T_env::Unitful.Quantity{Float64}

    "Operating pressure."
    P_env::Unitful.Quantity{Float64}

    "Efficiency of solids separator."
    ηseparator::Float64

    "Power applied to crusher."
    power_crusher::Unitful.Quantity{Float64}

    "Mass flow rate of cooling fluid."
    ṁ_cooler::Unitful.Quantity{Float64}

    "Mass flow rate of clinker."
    ṁ_clinker::Unitful.Quantity{Float64}

    "Mass flow rate of crushing auxiliary air."
    ṁ_cru_air::Unitful.Quantity{Float64}

    "Mass flow rate of separator auxiliary air."
    ṁ_sep_air::Unitful.Quantity{Float64}

    "Mass flow rate of parasite air in system."
    ṁ_par_air::Unitful.Quantity{Float64}

    "Mass flow rate of air at system exit."
    ṁ_tot_air::Unitful.Quantity{Float64}

    "Inlet temperature of cooling fluid."
    T_in_cool::Unitful.Quantity{Float64}

    "Outlet temperature of cooling fluid (forced mode)."
    T_out_cool::Union{Nothing, Unitful.Quantity{Float64}}

    "Inlet temperature of product in separator (forced mode)."
    T_in_sep::Union{Nothing, Unitful.Quantity{Float64}}

    "Outlet temperature of product in recirculation (forced mode)."
    T_out_rec::Union{Nothing, Unitful.Quantity{Float64}}

    "Crushing outlet temperature for simulation initial guess."
    T_out_crush::Union{Nothing, Unitful.Quantity{Float64}}

    function CooledCrusherInputs(; T_env, ηseparator, power_crusher, ṁ_cooler,
            ṁ_clinker, ṁ_cru_air, ṁ_sep_air, ṁ_par_air, ṁ_tot_air, kwargs...)

        kw = Dict(kwargs)

        kelvin_or_na(v) = isnothing(v) ? v : uconvert(u"K", v)

        return new(
            uconvert(u"K", T_env),
            uconvert(u"Pa", get(kw, :P_env, 1.0u"atm")),
            0.01ηseparator,
            uconvert(u"W", power_crusher),
            uconvert(u"kg/s", ṁ_cooler),
            uconvert(u"kg/s", ṁ_clinker),
            uconvert(u"kg/s", ṁ_cru_air),
            uconvert(u"kg/s", ṁ_sep_air),
            uconvert(u"kg/s", ṁ_par_air),
            uconvert(u"kg/s", ṁ_tot_air),
            uconvert(u"K", get(kw, :T_in_cool, T_env)),
            kelvin_or_na(get(kw, :T_out_cool, nothing)),
            kelvin_or_na(get(kw, :T_in_sep, nothing)),
            kelvin_or_na(get(kw, :T_out_rec, nothing)),
            kelvin_or_na(get(kw, :T_out_crush, nothing))
        )
    end
end

# ╔═╡ 299a3f06-5893-4b3d-beb8-c9770b0430f1
""" Solver parameters for `CooledCrusherModel`.

All attributes are optional and can be provided through key-words.

Attributes
----------
$(FIELDS)
"""
struct CooledCrusherSolverPars
    "Maximum number of solver iterations. Default is `100`."
    max_iter::Int64

    "Absolute tolerance for temperature. Default is `1.0e-10`."
    T_tol::Float64

    "Absolute tolerance for mass flow. Default is `1.0e-10`."
    ṁ_tol::Float64

    "Verbosity control flag. Default is `true`."
    verbose::Bool

    function CooledCrusherSolverPars(; kwargs...)
        kw = Dict(kwargs)
        return new(
            get(kw, :max_iter, 100),
            get(kw, :T_tol,    1.0e-10),
            get(kw, :ṁ_tol,    1.0e-10),
            get(kw, :verbose,  true)
        )
    end
end

# ╔═╡ 9b0788b4-de80-4da6-b9bd-464c490e478d
""" Creates unit operations for `CooledCrusherModel`.

Specific key-word arguments of this structure include the materials specification
with the following *pure fluid* defaults. If the user needs specific material
properties, the material must implement all the method interfaces provided for the
default materials below.

- `cooler  = (PureAir(),     [1.0])`
- `clinker = (PureMineral(), [1.0, 0.0])`
- `air     = (PureAir(),     [0.0, 1.0])`

Attributes
----------
$(FIELDS)
"""
struct CooledCrusherUnits
    "Cooling fluid materials pipeline."
    pipe_cool::StreamPipeline

    "Production fluid materials pipeline."
    pipe_prod::StreamPipeline

    "Energy stream applied to crushing mill."
    milling_power::EnergyStream

    "Crusher cooling stream."
    cooling_stream::MaterialStream

    "Clinker main feed stream."
    clinker_stream::MaterialStream

    "Auxiliary crusher air stream."
    crusher_air_stream::MaterialStream

    "Auxiliary separator air stream."
    separator_air_stream::MaterialStream

    "Parasite air stream mixed with clinker."
    parasite_air_stream::MaterialStream

    "Product recirculation stream."
    recirc_stream::MaterialStream

    "Balance air as complement to parasite air."
    balance_air_stream::MaterialStream

    "Premix of clinker and parasite air."
    meal_stream::MaterialStream

    "Crusher operation model."
    crusher::CooledCrushingMill

    "Separator operation model."
    separator::SolidsSeparator

    "Cyclone operation model."
    cyclone::SolidsSeparator

    "Pipeline between crusher and separator."
    transport_sep::TransportPipeline

    "Product recirculation pipeline."
    transport_rec::TransportPipeline

    function CooledCrusherUnits(inputs, solver; kwargs...)
        kw = Dict(kwargs)

        # Strip physical units.
        T_env         = ustrip(inputs.T_env)
        P_env         = ustrip(inputs.P_env)
        T_in_cool     = ustrip(inputs.T_in_cool)
        power_crusher = ustrip(inputs.power_crusher)
        ṁ_cooler      = ustrip(inputs.ṁ_cooler)
        ṁ_clinker     = ustrip(inputs.ṁ_clinker)
        ṁ_cru_air     = ustrip(inputs.ṁ_cru_air)
        ṁ_sep_air     = ustrip(inputs.ṁ_sep_air)
        ṁ_par_air     = ustrip(inputs.ṁ_par_air)
        ṁ_tot_air     = ustrip(inputs.ṁ_tot_air)

        val_or_na(qty) = isnothing(qty) ? qty : ustrip(qty)

        T_out_cool    = val_or_na(inputs.T_out_cool)
        T_in_sep      = val_or_na(inputs.T_in_sep)
        T_out_rec     = val_or_na(inputs.T_out_rec)
        T_out_crush   = val_or_na(inputs.T_out_crush)
            
        # Get material streams.
        cooler, Y_cool     = get(kw, :cooler,  (PureAir(),     [1.0]))
        clinker, Y_clinker = get(kw, :clinker, (PureMineral(), [1.0, 0.0]))
        air, Y_air         = get(kw, :air,     (PureAir(),     [0.0, 1.0]))

        pipe_cool = StreamPipeline([cooler])
        pipe_prod = StreamPipeline([clinker, air])

        # Aliases
        T, P = T_env, P_env

        # Applied power at mill.
        milling_power = EnergyStream(power_crusher)

        # Cooling material stream.
        cooling_stream = MaterialStream(
            ṁ_cooler, T_in_cool, P_env, Y_cool, pipe_cool)

        # Clinker material stream.
        clinker_stream = MaterialStream(
            ṁ_clinker, T_env, P_env, Y_clinker, pipe_prod)

        # Milling air stream.
        crusher_air_stream = MaterialStream(
            ṁ_cru_air, T_env, P_env, Y_air, pipe_prod)

        # Separator air stream.
        separator_air_stream = MaterialStream(
            ṁ_sep_air, T_env, P_env, Y_air, pipe_prod)

        # Air leaks in mill.
        parasite_air_stream = MaterialStream(
            ṁ_par_air, T_env, P_env, Y_air, pipe_prod)

        # Dummy recirculation for initialization.
        recirc_stream = MaterialStream(
            0.0, T_env, P_env, Y_clinker, pipe_prod)

        # XXX Experimental code.
        htc_sep = get(kw, :htc_pipe_sep, nothing)
        htc_rec = get(kw, :htc_pipe_rec, nothing)
        htc_cru = get(kw, :htc_cooling,  nothing)
        # temp_cru = T_out_crush
        
        # Premix meal that is not iterated upon.
        meal_stream = clinker_stream
        meal_stream += crusher_air_stream
        meal_stream += parasite_air_stream

        # Run iterative procedure till steady-state.
        itercount = 0
        ṁnow = 1.0e+09
        Tnow = 1.0e+09

        crusher = nothing
        separator = nothing
        transport_sep = nothing
        transport_rec = nothing

        # Tentative
        if !isnothing(htc_cru)
            _, T_out_cool, T_out_crush = cooled_crushing(
                product  = meal_stream + recirc_stream,
                coolant  = cooling_stream,
                power    = milling_power,
                temp_out = T_out_cool,
                temp_cru = T_out_crush, 
                glob_htc = nothing
            )
        end
        
        while itercount <= solver.max_iter
            # Mix meal and recirculation
            product = meal_stream + recirc_stream
            
            # Add crushing energy and cool down system.
            # TODO T_out_crush can be actually *computed*!
            crusher, T_out_cool, T_out_crush = cooled_crushing(
                product  = product,
                coolant  = cooling_stream,
                power    = milling_power,
                temp_out = T_out_cool,
                temp_cru = T_out_crush, 
                glob_htc = htc_cru
            )

            # Loose some heat in vertical pipeline.
            rets = transport_pipe(crusher.product, T_in_sep, T_env, htc_sep)
            transport_sep, T_in_sep = rets

            # Add air stream to crushed product.
            toseparator2 = transport_sep + separator_air_stream

            # Recover streams from separator
            separator = SolidsSeparator(toseparator2; η = inputs.ηseparator)

            # Loose some heat in recirculation pipeline.
            rets = transport_pipe(separator.solids, T_out_rec, T_env, htc_rec)
            transport_rec, T_out_rec = rets

            # Compute property changes.
            ΔT = abs(Tnow - transport_rec.product.T)
            Δṁ = abs(ṁnow - transport_rec.product.ṁ)

            # Check convergence.
            if ΔT < solver.T_tol && Δṁ < solver.ṁ_tol
                solver.verbose && begin
                    @info "CooledCrusherModel: $(itercount) iterations"
                end
                break
            end

            # Prepare next iteration.
            recirc_stream = transport_rec.product
            Tnow = recirc_stream.T
            ṁnow = recirc_stream.ṁ
            itercount += 1
        end

        cyclone = SolidsSeparator(separator.others; η = 1.0)

        # Total air leaving the system (after cyclone)
        balance_air_stream = MaterialStream(
            ṁ_tot_air - cyclone.others.ṁ, T, P, Y_air, pipe_prod)

        return new(
            pipe_cool,
            pipe_prod,
            milling_power,
            cooling_stream,
            clinker_stream,
            crusher_air_stream,
            separator_air_stream,
            parasite_air_stream,
            recirc_stream,
            balance_air_stream,
            meal_stream,
            crusher,
            separator,
            cyclone,
            transport_sep,
            transport_rec
        )
    end
end

# ╔═╡ e3579a9b-1d01-4959-b03e-de5cbcd2a291
""" Implements an air cooled crusher circuit.

Constructor parameters are described in `CooledCrusherInputs` together with
additional key-word arguments, which are extended in `CooledCrusherSolverPars`
and `CooledCrusherUnits`.

Attributes
----------
$(FIELDS)
"""
struct CooledCrusherModel
    "Processed model inputs with units."
    inputs::CooledCrusherInputs

    "Solver operations to manage operation units."
    solver::CooledCrusherSolverPars

    "*De facto* process integration model."
    unitops::CooledCrusherUnits

    function CooledCrusherModel(; T_env, ṁ_cooler, ṁ_clinker, ṁ_cru_air,
        ṁ_sep_air, ṁ_par_air, ṁ_tot_air, power_crusher, ηseparator, kwargs...)

        inputs = CooledCrusherInputs(; T_env, ηseparator, power_crusher, ṁ_cooler,
            ṁ_clinker, ṁ_cru_air, ṁ_sep_air, ṁ_par_air, ṁ_tot_air, kwargs...)

        solver = CooledCrusherSolverPars(; kwargs...)

        unitops = CooledCrusherUnits(inputs, solver; kwargs...)

        return new(inputs, solver, unitops)
    end
end

# ╔═╡ 8992b0f8-57c5-45d0-ba39-b77391620caa
"Compute normal flow rate based on measurements"
function normal_flow_rate(; T, ⌀, U)
    return 3600 * (T_REF / T) * U * π * ⌀^2 / 4
end

# ╔═╡ 62aac4ca-a132-4a3e-b3bd-9c1a186c7136
begin
    @info "Postprocessing implementation"

    "Default slider with displayed value."
    slider(rng, def) = PlutoUI.Slider(rng, default=def, show_value=true)

    "Standardized report for `CooledCrusherModel`."
    function report(model::CooledCrusherModel; show_tree = true)
        fmt(x) = round(x; digits = 1)

        cooling = model.unitops.cooling_stream
        crusher = model.unitops.crusher
        separator = model.unitops.separator
        trans_rec = model.unitops.transport_rec
        # T_out_rec = model.inputs.T_out_rec

        @info """
        CooledCrusherModel

        Cooling circuit:
        - inlet temperature...... $(fmt(cooling.T - T_REF)) °C
        - outlet temperature..... $(fmt(crusher.coolant.T - T_REF)) °C
        - energy intake.......... $(fmt(crusher.loss.ḣ / 1000)) kW

        Crusher circuit:
        - inlet temperature...... $(fmt(crusher.rawmeal.T - T_REF)) °C
        - outlet temperature..... $(fmt(crusher.product.T - T_REF)) °C

        Recirculation circuit:
        - flow rate.............. $(fmt(3600separator.solids.ṁ)) kg/h
        - initial temperature.... $(fmt(separator.solids.T - T_REF)) °C
        - final temperature...... $(fmt(trans_rec.product.T - T_REF)) °C

        """

        if show_tree
            @info model.inputs
            @info model.unitops
        end
    end

    "Graphical display of crusher balance results."
    function get_results_diagram(model; kwargs...)
        function inlet_main(p0, p1, p2, c)
            Luxor.sethue(c)
            Luxor.arrow(p0, p1)
            Luxor.move(p0)
            Luxor.line(p1)
            Luxor.line(p2)
            Luxor.strokepath()
        end

        kwargs_dict = Dict(kwargs)

        # For @svg
        height = get(kwargs_dict, :height, 300)
        width  = get(kwargs_dict, :width, 700)
        saveas = get(kwargs_dict, :saveas, "crusher.svg")

        # Display control
        showcrusher   = get(kwargs_dict, :showcrusher, true)
        showseparator = get(kwargs_dict, :showseparator, true)

        Luxor.@svg let
            colorbkg = "#EEEEEE"
            colorair = "#0055FF"
            colorsol = "#00AA44"
            colormix = "#FF552F"
            colorrfr = "#0099FF"

            Luxor.background(colorbkg)

            let # Leak air (7+9).
                p0 = Luxor.Point(-265, -50)
                p1 = Luxor.Point(-250, -50)
                p2 = Luxor.Point(-200, 0)
                inlet_main(p0, p1, p2, colorair)
            end

            let # Clinker inlet.
                p0 = Luxor.Point(-265, 50)
                p1 = Luxor.Point(-250, 50)
                p2 = Luxor.Point(-200, 0)
                inlet_main(p0, p1, p2, colorsol)
            end

            let # Crushing pipeline.
                p0 = Luxor.Point(-200, 0)
                p1 = Luxor.Point(125, 0)
                p2 = Luxor.Point(125, -100)
                p3 = Luxor.Point(200, -100)
                Luxor.sethue(colormix)
                Luxor.move(p0)
                Luxor.line(p1)
                Luxor.line(p2)
                Luxor.line(p3)
                Luxor.strokepath()
            end

            let # Crushing air inlet.
                p0 = Luxor.Point(-150, -50)
                p1 = Luxor.Point(-150, 0)
                Luxor.sethue(colorair)
                Luxor.arrow(p0, p1)
                Luxor.move(p0)
                Luxor.line(p1)
                Luxor.strokepath()
            end

            showcrusher && let # Crusher.
                Luxor.move(-50, 30)
                Luxor.line(Luxor.Point(100, 30))
                Luxor.line(Luxor.Point(100, -30))
                Luxor.line(Luxor.Point(-50, -30))
                Luxor.closepath()
                Luxor.sethue("orange"); Luxor.fillpreserve()
                Luxor.sethue("black"); Luxor.strokepath()
            end

            let # Cooling system.
                arrowheadlength = 10

                p0 = Luxor.Point(75, 60)
                p1 = Luxor.Point(75, 0)
                p2 = Luxor.Point(-25, 0)
                p3 = Luxor.Point(-25, 60)

                pm = Luxor.Point(75, 40)
                pn = Luxor.Point(-25, 40 + arrowheadlength)

                Luxor.sethue(colorrfr)
                Luxor.arrow(p0, pm; arrowheadlength)
                Luxor.arrow(p2, pn; arrowheadlength)
                Luxor.move(p0)
                Luxor.line(p1)
                Luxor.line(p2)
                Luxor.line(p3)
                Luxor.strokepath()
            end

            let # Separator air.
                p0 = Luxor.Point(100, -70)
                p1 = Luxor.Point(125, -70)
                Luxor.sethue(colorair)
                Luxor.arrow(p0, p1)
                Luxor.move(p0)
                Luxor.line(p1)
                Luxor.strokepath()
            end

            let # Recirculation pipe.
                p0 = Luxor.Point(125, -100)
                p1 = Luxor.Point(-100, -100)
                p2 = Luxor.Point(-100, 0)
                Luxor.sethue(colorsol)
                Luxor.arrow(p1, p2)
                Luxor.move(p0)
                Luxor.line(p1)
                Luxor.line(p2)
                Luxor.strokepath()
            end

            showseparator && let # Separator.
                Luxor.move(125, -80)
                Luxor.line(Luxor.Point(110, -114))
                Luxor.line(Luxor.Point(140, -114))
                Luxor.closepath()
                Luxor.sethue("gray"); Luxor.fillpreserve()
                Luxor.sethue("black"); Luxor.strokepath()
            end

            let # Packing products.
                p0 = Luxor.Point(200, -100)
                p1 = Luxor.Point(200, 0)
                Luxor.sethue(colorsol)
                Luxor.arrow(p0, p1)
                Luxor.move(p0)
                Luxor.line(p1)
                Luxor.strokepath()

                p0 = Luxor.Point(200, -100)
                p1 = Luxor.Point(250, -100)
                Luxor.sethue(colorair)
                Luxor.arrow(p0, p1)
                Luxor.move(p0)
                Luxor.line(p1)
                Luxor.strokepath()


                p0 = Luxor.Point(230, 0)
                p1 = Luxor.Point(230, -100)
                Luxor.sethue(colorair)
                Luxor.arrow(p0, p1)
                Luxor.move(p0)
                Luxor.line(p1)
                Luxor.strokepath()
            end

            showseparator && let # Packing.
                Luxor.move(200, -80)
                Luxor.line(Luxor.Point(185, -114))
                Luxor.line(Luxor.Point(215, -114))
                Luxor.closepath()
                Luxor.sethue("gray"); Luxor.fillpreserve()
                Luxor.sethue("black"); Luxor.strokepath()
            end

            let # Joining points.
                radius = 2
                Luxor.sethue("black")
                Luxor.circle(Luxor.Point(-200, 0), radius; action = :fill)
                Luxor.circle(Luxor.Point(-150, 0), radius; action = :fill)
                Luxor.circle(Luxor.Point(-100, 0), radius; action = :fill)
                Luxor.circle(Luxor.Point(125, -70), radius; action = :fill)
                Luxor.circle(Luxor.Point(230, -100), radius; action = :fill)
            end

            let # Add annotations
                inp = model.inputs
                ops = model.unitops

                crusher   = ops.crusher
                separator = ops.separator
                cyclone   = ops.cyclone

                trans_sep = ops.transport_sep
                trans_rec = ops.transport_rec

                liq_cool = ops.pipe_cool.materials[1] isa AbstractLiquidMaterial

                # halign = :center
                valign = :middle

                round1(x) = round(x; digits = 1)

                celsius(T) = round1(ustrip(T) - T_REF)

                crush_power = round1(crusher.power.ḣ / 1000)
                cooling_power = round1(crusher.loss.ḣ / 1000)

                ṁ_clinker = round1(3600ops.clinker_stream.ṁ)
                ṁ_recircs = round1(3600separator.solids.ṁ)
                ṁ_product = round1(3600cyclone.solids.ṁ)

				air_flow(q) = kg_h_to_nm3_h(3600q, M_AIR)
                q_par_air = round1(air_flow(ops.parasite_air_stream.ṁ))
                q_cru_air = round1(air_flow(ops.crusher_air_stream.ṁ))
                q_sep_air = round1(air_flow(ops.separator_air_stream.ṁ))
                q_tot_air = round1(air_flow(ustrip(inp.ṁ_tot_air)))
                q_oth_air = round1(air_flow(ops.balance_air_stream.ṁ))

                if liq_cool
                    q_cooling = "$(round1(3600ops.cooling_stream.ṁ)) kg/h (0)"
                else
                    q_cooling = "$(round1(air_flow(ops.cooling_stream.ṁ))) Nm³/h (0)"
                end

                T_env     = celsius(inp.T_env)
                T_crush1  = celsius(crusher.rawmeal.T)
                T_crush2  = celsius(crusher.product.T)
                T_coolant = celsius(crusher.coolant.T)
                T_recircs = celsius(separator.solids.T)
                T_in_sep  = celsius(trans_sep.product.T)
                T_out_rec = celsius(trans_rec.product.T)

                let # Controls
                    Luxor.sethue("black")

                    Luxor.text("Environment at $(T_env) °C",
                         Luxor.Point(-340, -140); valign, halign = :left)

                    Luxor.text("Crushing @ $(crush_power) kW",
                         Luxor.Point(25, -20); valign, halign = :center)

                    Luxor.text("Cooling @ $(-1cooling_power) kW",
                         Luxor.Point(25, 10); valign, halign = :center)

                    Luxor.text(q_cooling,
                         Luxor.Point(75, 65);  valign, halign = :left, angle = π/2)

                    Luxor.text("$(q_tot_air) Nm³/h (5)",
                         Luxor.Point(255, -100); valign, halign = :left)

                    Luxor.text("$(q_sep_air) Nm³/h (4)",
                         Luxor.Point(96,  -70);  valign, halign = :right)

                    Luxor.text("$(q_cru_air) Nm³/h (3)",
                         Luxor.Point(-150, -60);  valign, halign = :center)

                    Luxor.text("$(q_par_air) Nm³/h (2)",
                         Luxor.Point(-269, -50); valign, halign = :right)

                    Luxor.text("$(ṁ_clinker) kg/h (1)",
                         Luxor.Point(-269, 50); valign, halign = :right)

                    Luxor.text("$(q_oth_air) Nm³/h (6)",
                         Luxor.Point(240, -70); valign, halign = :left, angle = π/2)

                    Luxor.text("$(ṁ_product) kg/h",
                         Luxor.Point(210, -70); valign, halign = :left, angle = π/2)
                end

                let # Measurements
                    Luxor.sethue("#FF2299")

                    Luxor.text("$(T_coolant) °C",
                         Luxor.Point(-25, 65); valign, halign = :left, angle = π/2)

                    Luxor.text("$(T_out_rec) °C",
                         Luxor.Point(-90, -40); valign, halign = :left, angle = π/2)

                    Luxor.text("$(T_in_sep) °C",
                         Luxor.Point(135, -69); valign, halign = :left, angle = π/2)
                end

                let # Fitted
                    Luxor.sethue("#9922FF")

                    Luxor.text("$(ṁ_recircs) kg/h @ $(T_recircs) °C",
                         Luxor.Point(25, -110); valign, halign = :center)
                end

                let # Main result
                    Luxor.sethue("#FF0000")
                    Luxor.fontsize(16)

                    Luxor.text("$(T_crush1) °C",
                         Luxor.Point(-55, 15); valign, halign = :right)

                    Luxor.text("$(T_crush2) °C",
                         Luxor.Point(105, 15); valign, halign = :left)
                end
            end

        end width height saveas
    end
end;

# ╔═╡ 03017a47-11a1-4ada-9068-dfafd9f1201d
let
    M = [
        21.2   1.2   13.0  56.0;
        18.8   1.1   10.0  55.0;
        19.6   1.4   17.0  56.0;
        18.6   1.5   10.0  55.0;
        19.0   1.2   11.0  53.0;
        20.0   1.4   19.0  55.0;
        20.0   1.4   18.0  55.0;
        20.0   1.4   17.0  54.0;
    ]

    h(T) = SpecificH(P_REF * u"Pa", T)
    ρ(T) = density(PureWater(), T, P_REF * u"Pa")

    # h(T) =  4182.0u"J/(kg*K)" * T
    # ρ(T) = 996.0u"kg/m^3"

    V̇ = uconvert.(u"m^3/s", M[:, 2] * u"m^3/hr")
    T1 = uconvert.(u"K", M[:, 1] * u"°C")
    T2 = uconvert.(u"K", M[:, 4] * u"°C")

    ρw = map(ρ, T1)
    ΔH = map(h, T2) - map(h, T1)

    Q̇ = mean(uconvert.(u"kW", @. ρw * V̇ * ΔH))
    V̇ = mean(M[:, 2])

    @info """
    Reference cooling power.... $(round(ustrip(Q̇); digits = 1)) kW
    Mean water flow rate....... $(round(V̇; digits = 1)) m³/h
    """
end

# ╔═╡ d09c54fe-93b4-4d41-8ea5-b9a427415ad3
begin
    @info "Reference measured data"

    const ϕ             = 31.5
    const ηseparator    = 47.65

    const T_env         = 5.0
    const T_out_cool    = 93.0
    const T_in_sep      = 73.0
    const T_out_rec     = 39.0

    const q̇_tot_air     = 3600.0
    const q̇_cru_air     = 1881
    const q̇_sep_air     = 431.0

    const ṁ_clinker     = 820.0
    const power_crusher = 107.0

    # Flow rate at cooling system outlet
    const Q̇cool = normal_flow_rate(; T = T_out_cool + T_REF, ⌀ = 0.05, U = 13.6)

    # Separator air inlet.
    const Q̇seps = normal_flow_rate(; T = T_env + T_REF, ⌀ = 0.16, U = 10.0)

    # Leak flow rates at balls loading and clinker charger.
    const Q̇leak = let
        Q̇7 = normal_flow_rate(; T = T_env + T_REF, ⌀ = 0.20, U = 1.6)
        Q̇9 = normal_flow_rate(; T = T_env + T_REF, ⌀ = 0.18, U = 2.5)
        Q̇7 + Q̇9
    end
end;

# ╔═╡ ef826d66-e01d-49fe-a9d8-aa38dbdaa00e
refmodel, reffig = let
    # Contribution of leaks *through* crusher.
    Q̇avai = q̇_tot_air - q̇_cru_air - q̇_sep_air
    ϕwarn = 100Q̇leak / Q̇avai

    # Select how to compute leak.
    q̇_par_air = (q̇_tot_air - q̇_cru_air - q̇_sep_air) * ϕ / 100

    model = CooledCrusherModel(;
        ηseparator    = ηseparator,
        T_env         = T_env * u"°C",
        ṁ_cooler      = nm3_h_to_kg_h(Q̇cool, M_AIR) * u"kg/hr",
        ṁ_clinker     = ṁ_clinker * u"kg/hr",
        ṁ_cru_air     = nm3_h_to_kg_h(q̇_cru_air, M_AIR) * u"kg/hr",
        ṁ_sep_air     = nm3_h_to_kg_h(q̇_sep_air, M_AIR) * u"kg/hr",
        ṁ_par_air     = nm3_h_to_kg_h(q̇_par_air, M_AIR) * u"kg/hr",
        ṁ_tot_air     = nm3_h_to_kg_h(q̇_tot_air, M_AIR) * u"kg/hr",
        power_crusher = power_crusher * u"kW",
        T_in_cool     = T_env * u"°C",
        T_out_cool    = T_out_cool * u"°C",
        T_in_sep      = T_in_sep * u"°C",
        T_out_rec     = T_out_rec * u"°C",
        verbose       = false
    )

    report(model; show_tree = false)

    fig = get_results_diagram(model)

    model, fig
end;

# ╔═╡ 7840d300-9b93-4105-aba9-0b21a3e83e41
reffig

# ╔═╡ 78a252df-6b1f-4716-8632-637d0fab91dc
refmodel

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DocStringExtensions = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
Luxor = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
Roots = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
SteamTables = "43dc94dd-f011-5c5d-8ab2-5073432dc0ba"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[compat]
DocStringExtensions = "~0.9.3"
Luxor = "~3.8.0"
Roots = "~2.1.5"
SteamTables = "~1.4.1"
Unitful = "~1.19.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "69ac39b800d103906dcae12896d09116d94fbcfe"

[[deps.Accessors]]
deps = ["CompositionsBase", "ConstructionBase", "Dates", "InverseFunctions", "LinearAlgebra", "MacroTools", "Markdown", "Test"]
git-tree-sha1 = "c0d491ef0b135fd7d63cbc6404286bc633329425"
uuid = "7d9f7c33-5ae7-4f3b-8dc6-eff91059b697"
version = "0.1.36"

    [deps.Accessors.extensions]
    AccessorsAxisKeysExt = "AxisKeys"
    AccessorsIntervalSetsExt = "IntervalSets"
    AccessorsStaticArraysExt = "StaticArrays"
    AccessorsStructArraysExt = "StructArrays"
    AccessorsUnitfulExt = "Unitful"

    [deps.Accessors.weakdeps]
    AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    Requires = "ae029012-a4dd-5104-9daa-d747884805df"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9e2a6b69137e6969bab0152632dcb3bc108c8bdd"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+1"

[[deps.Cairo]]
deps = ["Cairo_jll", "Colors", "Glib_jll", "Graphics", "Libdl", "Pango_jll"]
git-tree-sha1 = "d0b3f8b4ad16cb0a2988c6788646a5e6a17b6b1b"
uuid = "159f3aea-2a34-519c-b102-8c37f9878175"
version = "1.0.5"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "a4c43f59baa34011e303e76f5c8c91bf58415aaf"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.0+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "575cd02e080939a33b6df6c5853d14924c08e35b"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.23.0"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "c955881e3c981181362ae4088b35995446298b80"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.14.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.CompositionsBase]]
git-tree-sha1 = "802bb88cd69dfd1509f6670416bd4434015693ad"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.2"
weakdeps = ["InverseFunctions"]

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "260fd2400ed2dab602a7c15cf10c1933c59930a2"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.5"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "0f4b5d62a88d8f59003e43c25a8a90de9eb76317"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.18"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "4558ab818dcceaab612d1bb8c19cee87eda2b83c"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.5.0+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "82d8afa92ecf4b52d78d869f038ebfb881267322"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.16.3"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "cf0fe81336da9fb90944683b8c41984b08793dad"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.36"

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

    [deps.ForwardDiff.weakdeps]
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d8db6a5a2fe1381c1ea4ef2cab7c69c2de7f9ea0"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.1+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "359a1ba2e320790ddbe4ee8b4d54a305c0ea2aff"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.80.0+0"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "896385798a8d49a255c398bd49162062e4a4c435"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.13"
weakdeps = ["Dates"]

    [deps.InverseFunctions.extensions]
    DatesExt = "Dates"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3336abae9a713d2210bb57ab484b1e065edd7d23"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.0.2+0"

[[deps.Juno]]
deps = ["Base64", "Logging", "Media", "Profile"]
git-tree-sha1 = "07cb43290a840908a771552911a6274bc6c072c7"
uuid = "e5e0dc1b-0480-54bc-9374-aad01c23163d"
version = "0.8.4"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d986ce2d884d49126836ea94ed5bfb0f12679713"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "15.0.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "f9557a255370125b405568f9767d6d195822a175"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "dae976433497a2f841baadea93d27e68f1a12a97"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.39.3+0"

[[deps.Librsvg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pango_jll", "Pkg", "gdk_pixbuf_jll"]
git-tree-sha1 = "ae0923dab7324e6bc980834f709c4cd83dd797ed"
uuid = "925c91fb-5dd6-59dd-8e8c-345e74382d89"
version = "2.54.5+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "6355fb9a4d22d867318db186fd09b09b35bd2ed7"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.6.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "0a04a1318df1bf510beb2562cf90fb0c386f58c4"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.39.3+1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "18144f3e9cbe9b15b070288eef858f71b291ce37"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.27"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Luxor]]
deps = ["Base64", "Cairo", "Colors", "DataStructures", "Dates", "FFMPEG", "FileIO", "Juno", "LaTeXStrings", "PrecompileTools", "Random", "Requires", "Rsvg"]
git-tree-sha1 = "aa3eb624552373a6204c19b00e95ce62ea932d32"
uuid = "ae8d54c2-7ccd-5906-9d76-62fc9837b5bc"
version = "3.8.0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Media]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "75a54abd10709c01f1b86b84ec225d26e840ed58"
uuid = "e89f7d12-3494-54d1-8411-f7d8b9ae1f27"
version = "0.5.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "60e3045590bd104a16fefb12836c00c0ef8c7f8c"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.13+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+0"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "526f5a03792669e4187e584e8ec9d534248ca765"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.52.1+0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "64779bc4c9784fee475689a1752ef4d5747c5e87"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.42.2+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Roots]]
deps = ["Accessors", "ChainRulesCore", "CommonSolve", "Printf"]
git-tree-sha1 = "1ab580704784260ee5f45bffac810b152922747b"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "2.1.5"

    [deps.Roots.extensions]
    RootsForwardDiffExt = "ForwardDiff"
    RootsIntervalRootFindingExt = "IntervalRootFinding"
    RootsSymPyExt = "SymPy"
    RootsSymPyPythonCallExt = "SymPyPythonCall"

    [deps.Roots.weakdeps]
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    IntervalRootFinding = "d2bf35a9-74e0-55ec-b149-d360ff49b807"
    SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
    SymPyPythonCall = "bc8888f7-b21e-4b7c-a06a-5d9c9496438c"

[[deps.Rsvg]]
deps = ["Cairo", "Glib_jll", "Librsvg_jll"]
git-tree-sha1 = "3d3dc66eb46568fb3a5259034bfc752a0eb0c686"
uuid = "c4c386cf-5103-5370-be45-f3a111cca3b8"
version = "1.0.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "e2cfc4012a19088254b3950b85c3c1d8882d864d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.3.1"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SteamTables]]
deps = ["ForwardDiff", "PrecompileTools", "Roots", "Unitful"]
git-tree-sha1 = "a03b9ec4ee2d895b9483544d4c61c21089fd2733"
uuid = "43dc94dd-f011-5c5d-8ab2-5073432dc0ba"
version = "1.4.1"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "3c793be6df9dd77a0cf49d80984ef9ff996948fa"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.19.0"
weakdeps = ["ConstructionBase", "InverseFunctions"]

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "07e470dabc5a6a4254ffebc29a1b3fc01464e105"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.12.5+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "31c421e5516a6248dfb22c194519e37effbf1f30"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.6.1+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "afead5aba5aa507ad5a3bf01f58f82c8d1403495"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+0"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6035850dcc70518ca32f012e46015b9beeda49d8"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "34d526d318358a859d7de23da945578e8e8727b7"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8fdda4c692503d44d04a0603d9ac0982054635f9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "b4bfde5d5b652e22b9c790ad00af08b6d042b97d"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.15.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e92a1a012a10506618f10b7047e478403a046c77"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "49ce682769cd5de6c72dcf1b94ed7790cd08974c"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.5+0"

[[deps.gdk_pixbuf_jll]]
deps = ["Artifacts", "Glib_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Xorg_libX11_jll", "libpng_jll"]
git-tree-sha1 = "86e7731be08b12fa5e741f719603ae740e16b666"
uuid = "da03df04-f53b-5353-a52f-6a8b0620ced0"
version = "2.42.10+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "d7015d2e18a5fd9a4f47de711837e980519781a4"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.43+1"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"
"""

# ╔═╡ Cell order:
# ╟─aa8086be-ec51-11ee-2ca0-933674507b58
# ╟─85be503e-eedf-49b4-952b-f581e71249ba
# ╟─299a3f06-5893-4b3d-beb8-c9770b0430f1
# ╟─9b0788b4-de80-4da6-b9bd-464c490e478d
# ╟─e3579a9b-1d01-4959-b03e-de5cbcd2a291
# ╟─8992b0f8-57c5-45d0-ba39-b77391620caa
# ╟─62aac4ca-a132-4a3e-b3bd-9c1a186c7136
# ╟─03017a47-11a1-4ada-9068-dfafd9f1201d
# ╟─d09c54fe-93b4-4d41-8ea5-b9a427415ad3
# ╟─7840d300-9b93-4105-aba9-0b21a3e83e41
# ╟─ef826d66-e01d-49fe-a9d8-aa38dbdaa00e
# ╠═78a252df-6b1f-4716-8632-637d0fab91dc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
