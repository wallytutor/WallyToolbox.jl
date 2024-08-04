### A Pluto.jl notebook ###
# v0.19.45

using Markdown
using InteractiveUtils

# ╔═╡ aa8086be-ec51-11ee-2ca0-933674507b58
begin
    @info "Loading tools..."
    import Pkg
    Pkg.activate(Base.current_project())

    import Unitful

    using DocStringExtensions: FIELDS
    using Luxor
    using Roots: find_zero
    using Statistics: mean
    using SteamTables: SpecificH
    using Unitful: @u_str, uconvert, ustrip

    using WallyToolbox: AbstractLiquidMaterial
    using WallyToolbox
    using DryFlowsheet
end

# ╔═╡ 0b802603-00d0-4418-85ba-78e5a1e72b32
md"""
# Creating a custom balance model
"""

# ╔═╡ 537d2369-fa2f-4a02-bb03-216582a5ef11
"Convert [Nm³/h] to [kg/h]."
nm3_h_to_kg_h(q, mw) = C_REF * mw  * q

# ╔═╡ bce23e3c-35ad-4584-b3f0-1e3e39af66b0
"Convert [kg/h] to [Nm³/h]."
kg_h_to_nm3_h(ṁ, mw) = ṁ / (C_REF * mw)

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
    T_out_cool::Union{Nothing,Unitful.Quantity{Float64}}

    "Inlet temperature of product in separator (forced mode)."
    T_in_sep::Union{Nothing,Unitful.Quantity{Float64}}

    "Outlet temperature of product in recirculation (forced mode)."
    T_out_rec::Union{Nothing,Unitful.Quantity{Float64}}

    "Crushing outlet temperature for simulation initial guess."
    T_out_crush::Union{Nothing,Unitful.Quantity{Float64}}

    function CooledCrusherInputs(;
        T_env,
        ηseparator,
        power_crusher,
        ṁ_cooler,
        ṁ_clinker,
        ṁ_cru_air,
        ṁ_sep_air,
        ṁ_par_air,
        ṁ_tot_air,
        kwargs...,
    )

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
            kelvin_or_na(get(kw, :T_out_crush, nothing)),
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
            get(kw, :T_tol, 1.0e-10),
            get(kw, :ṁ_tol, 1.0e-10),
            get(kw, :verbose, true),
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
        T_env = ustrip(inputs.T_env)
        P_env = ustrip(inputs.P_env)
        T_in_cool = ustrip(inputs.T_in_cool)
        power_crusher = ustrip(inputs.power_crusher)
        ṁ_cooler = ustrip(inputs.ṁ_cooler)
        ṁ_clinker = ustrip(inputs.ṁ_clinker)
        ṁ_cru_air = ustrip(inputs.ṁ_cru_air)
        ṁ_sep_air = ustrip(inputs.ṁ_sep_air)
        ṁ_par_air = ustrip(inputs.ṁ_par_air)
        ṁ_tot_air = ustrip(inputs.ṁ_tot_air)

        val_or_na(qty) = isnothing(qty) ? qty : ustrip(qty)

        T_out_cool = val_or_na(inputs.T_out_cool)
        T_in_sep = val_or_na(inputs.T_in_sep)
        T_out_rec = val_or_na(inputs.T_out_rec)
        T_out_crush = val_or_na(inputs.T_out_crush)

        # Get material streams.
        cooler, Y_cool = get(kw, :cooler, (PureAir(), [1.0]))
        clinker, Y_clinker = get(kw, :clinker, (PureMineral(), [1.0, 0.0]))
        air, Y_air = get(kw, :air, (PureAir(), [0.0, 1.0]))

        pipe_cool = StreamPipeline([cooler])
        pipe_prod = StreamPipeline([clinker, air])

        # Aliases
        T, P = T_env, P_env

        # Applied power at mill.
        milling_power = EnergyStream(power_crusher)

        # Cooling material stream.
        cooling_stream = MaterialStream(ṁ_cooler, T_in_cool, P_env, Y_cool, pipe_cool)

        # Clinker material stream.
        clinker_stream = MaterialStream(ṁ_clinker, T_env, P_env, Y_clinker, pipe_prod)

        # Milling air stream.
        crusher_air_stream = MaterialStream(ṁ_cru_air, T_env, P_env, Y_air, pipe_prod)

        # Separator air stream.
        separator_air_stream = MaterialStream(ṁ_sep_air, T_env, P_env, Y_air, pipe_prod)

        # Air leaks in mill.
        parasite_air_stream = MaterialStream(ṁ_par_air, T_env, P_env, Y_air, pipe_prod)

        # Dummy recirculation for initialization.
        recirc_stream = MaterialStream(0.0, T_env, P_env, Y_clinker, pipe_prod)

        # XXX Experimental code.
        htc_sep = get(kw, :htc_pipe_sep, nothing)
        htc_rec = get(kw, :htc_pipe_rec, nothing)
        htc_cru = get(kw, :htc_cooling, nothing)
        # temp_cru = T_out_crush

        # Premix meal that is not iterated upon.
        meal_stream = clinker_stream
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
                product = meal_stream + recirc_stream,
                coolant = cooling_stream,
                power = milling_power,
                temp_out = T_out_cool,
                temp_cru = T_out_crush,
                glob_htc = nothing,
            )
        end

        while itercount <= solver.max_iter
            # Mix meal and recirculation
            product = meal_stream + recirc_stream

            # Add crushing energy and cool down system.
            # TODO T_out_crush can be actually *computed*!
            mid_crusher, T_out_cool, T_out_crush = cooled_crushing(
                product = product,
                coolant = cooling_stream,
                power = milling_power,
                temp_out = T_out_cool,
                temp_cru = T_out_crush,
                glob_htc = htc_cru,
            )

            # Mix crusher product with *dilution air*
            crusher = CooledCrushingMill(
                mid_crusher.rawmeal,
                mid_crusher.product + crusher_air_stream,
                mid_crusher.coolant,
                mid_crusher.power,
                mid_crusher.loss,
                mid_crusher.globalhtc,
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
        balance_air_stream =
            MaterialStream(ṁ_tot_air - cyclone.others.ṁ, T, P, Y_air, pipe_prod)

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
            transport_rec,
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

    function CooledCrusherModel(;
        T_env,
        ṁ_cooler,
        ṁ_clinker,
        ṁ_cru_air,
        ṁ_sep_air,
        ṁ_par_air,
        ṁ_tot_air,
        power_crusher,
        ηseparator,
        kwargs...,
    )

        inputs = CooledCrusherInputs(;
            T_env,
            ηseparator,
            power_crusher,
            ṁ_cooler,
            ṁ_clinker,
            ṁ_cru_air,
            ṁ_sep_air,
            ṁ_par_air,
            ṁ_tot_air,
            kwargs...,
        )

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
    slider(rng, def) = PlutoUI.Slider(rng, default = def, show_value = true)

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
        width = get(kwargs_dict, :width, 700)
        saveas = get(kwargs_dict, :saveas, "crusher.svg")

        # Display control
        showcrusher = get(kwargs_dict, :showcrusher, true)
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
                p0 = Luxor.Point(110, -40)
                p1 = Luxor.Point(110, 0)
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
                Luxor.sethue("orange")
                Luxor.fillpreserve()
                Luxor.sethue("black")
                Luxor.strokepath()
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
                Luxor.sethue("gray")
                Luxor.fillpreserve()
                Luxor.sethue("black")
                Luxor.strokepath()
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
                Luxor.sethue("gray")
                Luxor.fillpreserve()
                Luxor.sethue("black")
                Luxor.strokepath()
            end

            let # Joining points.
                radius = 2
                Luxor.sethue("black")
                Luxor.circle(Luxor.Point(-200, 0), radius; action = :fill)
                Luxor.circle(Luxor.Point(-100, 0), radius; action = :fill)
                Luxor.circle(Luxor.Point(110, 0), radius; action = :fill)
                Luxor.circle(Luxor.Point(125, -70), radius; action = :fill)
                Luxor.circle(Luxor.Point(230, -100), radius; action = :fill)
            end

            let # Add annotations
                inp = model.inputs
                ops = model.unitops

                crusher = ops.crusher
                separator = ops.separator
                cyclone = ops.cyclone

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

                T_env = celsius(inp.T_env)
                T_crush1 = celsius(crusher.rawmeal.T)
                T_crush2 = celsius(crusher.product.T)
                T_coolant = celsius(crusher.coolant.T)
                T_recircs = celsius(separator.solids.T)
                T_in_sep = celsius(trans_sep.product.T)
                T_out_rec = celsius(trans_rec.product.T)

                let # Controls
                    Luxor.sethue("black")

                    Luxor.text(
                        "Environment at $(T_env) °C",
                        Luxor.Point(-340, -140);
                        valign,
                        halign = :left,
                    )

                    Luxor.text(
                        "Crushing @ $(crush_power) kW",
                        Luxor.Point(25, -20);
                        valign,
                        halign = :center,
                    )

                    Luxor.text(
                        "Cooling @ $(-1cooling_power) kW",
                        Luxor.Point(25, 10);
                        valign,
                        halign = :center,
                    )

                    Luxor.text(
                        q_cooling,
                        Luxor.Point(75, 65);
                        valign,
                        halign = :left,
                        angle = π / 2,
                    )

                    Luxor.text(
                        "$(q_tot_air) Nm³/h (5)",
                        Luxor.Point(255, -100);
                        valign,
                        halign = :left,
                    )

                    Luxor.text(
                        "$(q_sep_air) Nm³/h (4)",
                        Luxor.Point(96, -70);
                        valign,
                        halign = :right,
                    )

                    Luxor.text(
                        "$(q_cru_air) Nm³/h (3)",
                        Luxor.Point(100, -45);
                        valign,
                        halign = :right,
                    )

                    Luxor.text(
                        "$(q_par_air) Nm³/h (2)",
                        Luxor.Point(-269, -50);
                        valign,
                        halign = :right,
                    )

                    Luxor.text(
                        "$(ṁ_clinker) kg/h (1)",
                        Luxor.Point(-269, 50);
                        valign,
                        halign = :right,
                    )

                    Luxor.text(
                        "$(q_oth_air) Nm³/h (6)",
                        Luxor.Point(240, -70);
                        valign,
                        halign = :left,
                        angle = π / 2,
                    )

                    Luxor.text(
                        "$(ṁ_product) kg/h",
                        Luxor.Point(210, -70);
                        valign,
                        halign = :left,
                        angle = π / 2,
                    )
                end

                let # Measurements
                    Luxor.sethue("#FF2299")

                    Luxor.text(
                        "$(T_coolant) °C",
                        Luxor.Point(-25, 65);
                        valign,
                        halign = :left,
                        angle = π / 2,
                    )

                    Luxor.text(
                        "$(T_out_rec) °C",
                        Luxor.Point(-90, -40);
                        valign,
                        halign = :left,
                        angle = π / 2,
                    )

                    Luxor.text(
                        "$(T_in_sep) °C",
                        Luxor.Point(135, -69);
                        valign,
                        halign = :left,
                        angle = π / 2,
                    )
                end

                let # Fitted
                    Luxor.sethue("#9922FF")

                    Luxor.text(
                        "$(ṁ_recircs) kg/h @ $(T_recircs) °C",
                        Luxor.Point(25, -110);
                        valign,
                        halign = :center,
                    )
                end

                let # Main result
                    Luxor.sethue("#FF0000")
                    Luxor.fontsize(16)

                    Luxor.text(
                        "$(T_crush1) °C",
                        Luxor.Point(-55, 15);
                        valign,
                        halign = :right,
                    )

                    Luxor.text(
                        "$(T_crush2) °C",
                        Luxor.Point(105, 15);
                        valign,
                        halign = :left,
                    )
                end
            end

        end width height saveas
    end
end;

# ╔═╡ 03017a47-11a1-4ada-9068-dfafd9f1201d
let
    M = [
        21.2 1.2 13.0 56.0
        18.8 1.1 10.0 55.0
        19.6 1.4 17.0 56.0
        18.6 1.5 10.0 55.0
        19.0 1.2 11.0 53.0
        20.0 1.4 19.0 55.0
        20.0 1.4 18.0 55.0
        20.0 1.4 17.0 54.0
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

    const ϕ = 77.64
    const ηseparator = 47.65

    const T_env = 7.0
    const T_out_cool = 75.0
    const T_in_sep = 73.0
    const T_out_rec = 39.0

    const q̇_tot_air = 3600.0
    const q̇_cru_air = 1881.0
    const q̇_sep_air = 431.0

    const ṁ_clinker = 820.0
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
        ηseparator = ηseparator,
        T_env = T_env * u"°C",
        ṁ_cooler = nm3_h_to_kg_h(Q̇cool, M_AIR) * u"kg/hr",
        ṁ_clinker = ṁ_clinker * u"kg/hr",
        ṁ_cru_air = nm3_h_to_kg_h(q̇_cru_air, M_AIR) * u"kg/hr",
        ṁ_sep_air = nm3_h_to_kg_h(q̇_sep_air, M_AIR) * u"kg/hr",
        ṁ_par_air = nm3_h_to_kg_h(q̇_par_air, M_AIR) * u"kg/hr",
        ṁ_tot_air = nm3_h_to_kg_h(q̇_tot_air, M_AIR) * u"kg/hr",
        power_crusher = power_crusher * u"kW",
        T_in_cool = T_env * u"°C",
        T_out_cool = T_out_cool * u"°C",
        T_in_sep = T_in_sep * u"°C",
        T_out_rec = T_out_rec * u"°C",
        verbose = false,
    )

    report(model; show_tree = false)

    fig = get_results_diagram(model)

    model, fig
end;

# ╔═╡ 7840d300-9b93-4105-aba9-0b21a3e83e41
reffig

# ╔═╡ 78a252df-6b1f-4716-8632-637d0fab91dc
refmodel

# ╔═╡ Cell order:
# ╟─0b802603-00d0-4418-85ba-78e5a1e72b32
# ╟─aa8086be-ec51-11ee-2ca0-933674507b58
# ╟─537d2369-fa2f-4a02-bb03-216582a5ef11
# ╟─bce23e3c-35ad-4584-b3f0-1e3e39af66b0
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
# ╟─78a252df-6b1f-4716-8632-637d0fab91dc
