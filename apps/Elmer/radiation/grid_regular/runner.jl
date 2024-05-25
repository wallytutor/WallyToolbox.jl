# -*- coding: utf-8 -*-
import GLMakie
using DelimitedFiles
using Polynomials
using Printf
using Statistics
using WallyToolbox
using DryUtilities: redirect_to_files

const MESH = "porous050"

function makesifstring(T)
    """\
    Header
        CHECK KEYWORDS Warn
        Mesh DB "." "$(MESH)"
        Include Path ""
        Results Directory ""
    End

    Simulation
        Max Output Level = 5
        Coordinate System = Cartesian
        Coordinate Mapping(3) = 1 2 3
        Simulation Type = Steady state
        Steady State Max Iterations = 50
        Output Intervals(1) = 1
        Solver Input File = case.sif
    End

    Constants
        Gravity(4) = 0 -1 0 9.82
        Stefan Boltzmann = 5.670374419e-08
        Permittivity of Vacuum = 8.85418781e-12
        Permeability of Vacuum = 1.25663706e-6
        Boltzmann Constant = 1.380649e-23
        Unit Charge = 1.6021766e-19
    End

    Body 1
        Target Bodies(1) = 1
        Name = "Body 1"
        Equation = 1
        Material = 1
        Initial condition = 1
    End

    Solver 1
        Equation = Heat Equation
        Variable = Temperature
        Procedure = "HeatSolve" "HeatSolver"
        Exec Solver = Always
        Stabilize = True
        Optimize Bandwidth = True
        Steady State Convergence Tolerance = 1.0e-8
        Nonlinear System Convergence Tolerance = 1.0e-9
        Nonlinear System Max Iterations = 20
        Nonlinear System Newton After Iterations = 3
        Nonlinear System Newton After Tolerance = 1.0e-3
        Nonlinear System Relaxation Factor = 1
        Linear System Solver = Iterative
        Linear System Iterative Method = BiCGStab
        Linear System Max Iterations = 500
        Linear System Convergence Tolerance = 1.0e-10
        BiCGstabl polynomial degree = 2
        Linear System Preconditioning = ILU1
        Linear System ILUT Tolerance = 1.0e-3
        Linear System Abort Not Converged = True
        Linear System Residual Output = 10
        Linear System Precondition Recompute = 1
    End

    Solver 2
        Equation = SaveLine
        Save Flux = True
        Filename = bflux.dat
        Flux Coefficient = Heat Conductivity
        Flux Variable = Temperature
        Procedure = "SaveData" "SaveLine"
        Exec Solver = After Simulation
        Stabilize = True
    End

    Equation 1
        Name = "Conduction"
        Active Solvers(1) = 1
    End

    Equation 2
        Name = "Boundary Flux"
        Active Solvers(1) = 2
    End

    Material 1
        Name = "Solid"
        Heat Conductivity = Variable Temperature
          Real MATC "1.0 - (0.5 / 900.0) * tx"
        Density = 3000.0
    End

    Initial Condition 1
        Name = "State"
        Temperature = 298.15
    End

    Boundary Condition 1
        Target Boundaries(1) = 1 
        Name = "Heat Source"
        Temperature = $(T)
        Save Line = False
    End

    Boundary Condition 2
        Target Boundaries(1) = 2 
        Name = "Heat Sink"
        Heat Transfer Coefficient = 100
        External Temperature = $(T-1.0)
        Save Line = True
    End

    Boundary Condition 3
        Target Boundaries(1) = 3 
        Name = "Symmetry 2D"
        Heat Flux = 0
        Save Line = False
    End

    Boundary Condition 4
        Target Boundaries(1) = 4 
        Name = "Internal"
        Emissivity = 1.0
        Radiation Boundary = 1
        Radiation Target Body = -1
        Radiation = Diffuse Gray
    End
    """
end

function conductivity(T)
    data = readdlm("bflux.dat")
    Lx = mean(data[:, 4])
    Tc = mean(data[:, 7])
    qx = mean(data[:, end])
    return -1 * qx * Lx / (T - Tc)
end

function workflow(T)
    @info "Running for $(T) K"

    open("case.sif", "w") do fp
        write(fp, makesifstring(T))
    end

    redirect_to_files("log.solver") do
        run(`ElmerSolver`)
    end

    return conductivity(T)
end

function workflow()
    open("ELMERSOLVER_STARTINFO", "w") do fp
        write(fp, "case.sif\n1\n")
    end
    
    Ts = collect(300:100:1200)
    ks = map(workflow, Ts)

    rm("ELMERSOLVER_STARTINFO"; force = true)
    @info "DONE!"

    return Ts, ks
end


Ts, ks = workflow()

p2 = fit(Ts, ks, 2)
p3 = fit(Ts, ks, 3)
p4 = fit(Ts, ks, 4)

ε3 = map(abs2, p3.(Ts) .- ks)
ε4 = map(abs2, p4.(Ts) .- ks)

fig = GLMakie.with_theme() do
    f = GLMakie.Figure(size = (900, 500))

    ax = GLMakie.Axis(f[1, 1])
    ax.xlabel = "Temperature [K]"
    ax.ylabel = "Thermal Conductivity [J·m⁻¹·K⁻¹]"
    GLMakie.lines!(ax, Ts, ks)
    GLMakie.scatter!(ax, Ts, p3.(Ts); color = :red)

    # ax = GLMakie.Axis(f[1, 2])
    # ax.xlabel = "Temperature [K]"
    # ax.ylabel = "Fit Error [J·m⁻¹·K⁻¹]"
    # GLMakie.lines!(ax, Ts, ε3; color = :red,  label = "⟨ε₃⟩ = $(@sprintf("%.3e", mean(ε3)))")
    # GLMakie.lines!(ax, Ts, ε4; color = :blue, label = "⟨ε₄⟩ = $(@sprintf("%.3e", mean(ε4)))")
    # GLMakie.axislegend(ax)

    f
end

# TODO add elasticity effects to quantification
# TODO add linearly decreasing conductivity law
# save("conductivity.png", fig)
