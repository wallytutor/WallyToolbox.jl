module RadCalNet

using cuDNN
using CUDA
using DelimitedFiles
using DocStringExtensions
using JLD2
using Flux
using HDF5
using Plots
using Printf
using ProgressMeter
using Statistics
using StatsBase
using YAML

# XXX: this is the version of the trained model, not the package!
const MODELVERSION::String = "v1.0.0"

const RADCALROOT = joinpath(@__DIR__, "data/radcal/$(MODELVERSION)")
const FILESCALER = joinpath(RADCALROOT, "scaler.yaml")
const FILEMODEL  = joinpath(RADCALROOT, "model.jld2")

##############################################################################
# Database
##############################################################################

"""
    runradcalinput(;
        X::Dict{String, Float64} = Dict{String, Float64}(),
        T::Float64 = 300.0,
        L::Float64 = 1.0,
        P::Float64 = 1.0,
        FV::Float64 = 0.0,
        OMMIN::Float64 = 50.0,
        OMMAX::Float64 = 10000.0,
        TWALL::Float64 = 500.0,
        radcalexe::String = "radcal_win_64.exe"
    )::Vector{Float64}

Create RADCAL.IN from template file and dump to disk.

**NOTE:** the user is responsible to provide a vector `X` of mole
fractions of species that sums up to one. If this is not respected
RADCAL fails. The Following list provides the indexes of available
species in vector `X`.

| Index | Species | Index | Species | Index | Species |
| ----: | :------ | ----: | :------ | ----: | :------ |
| 1     | CO2     | 6     | C2H6    | 11    | CH3OH   |
| 2     | H2O     | 7     | C3H6    | 12    | MMA     |
| 3     | CO      | 8     | C3H8    | 13    | O2      |
| 4     | CH4     | 9     | C7H8    | 14    | N2      |
| 5     | C2H4    | 10    | C7H16   |       |         |
"""
function runradcalinput(;
        X::Vector{Float64},
        T::Float64 = 300.0,
        L::Float64 = 1.0,
        P::Float64 = 1.0,
        FV::Float64 = 0.0,
        OMMIN::Float64 = 50.0,
        OMMAX::Float64 = 10000.0,
        TWALL::Float64 = 500.0,
        radcalexe::String = "radcal_win_64.exe"
    )::Vector{Float64}
    case = """\
        CASE:
        &HEADER TITLE="CASE" CHID="CASE" /
        &BAND OMMIN = $(@sprintf("%.16E", OMMIN))
              OMMAX = $(@sprintf("%.16E", OMMAX)) /
        &WALL TWALL = $(@sprintf("%.16E", TWALL)) /
        &PATH_SEGMENT
            T        = $(@sprintf("%.16E", T))
            LENGTH   = $(@sprintf("%.16E", L))
            PRESSURE = $(@sprintf("%.16E", P))
            XCO2     = $(@sprintf("%.16E", X[1]))
            XH2O     = $(@sprintf("%.16E", X[2]))
            XCO      = $(@sprintf("%.16E", X[3]))
            XCH4     = $(@sprintf("%.16E", X[4]))
            XC2H4    = $(@sprintf("%.16E", X[5]))
            XC2H6    = $(@sprintf("%.16E", X[6]))
            XC3H6    = $(@sprintf("%.16E", X[7]))
            XC3H8    = $(@sprintf("%.16E", X[8]))
            XC7H8    = $(@sprintf("%.16E", X[9]))
            XC7H16   = $(@sprintf("%.16E", X[10]))
            XCH3OH   = $(@sprintf("%.16E", X[11]))
            XMMA     = $(@sprintf("%.16E", X[12]))
            XO2      = $(@sprintf("%.16E", X[13]))
            XN2      = $(@sprintf("%.16E", X[14]))
            FV       = $(@sprintf("%.16E", FV)) /\
        """

    write("RADCAL.IN", case)

    run(`$radcalexe RADCAL.in`)

    data = readlines("RADCAL.OUT")

    @assert !startswith(data[1], "ERROR") "RadCal ailed: $(data[1])"

    f = r->(r |> strip |> s->split(s, "\t") |> last |> s->parse(Float64, s))

    return [OMMIN, OMMAX, TWALL, T, L, P, FV, X..., map(f, data[5:9])...]
end

"""
    createcustomdatabase(;
        sampler!::Function,
        repeats::Int64 = 100,
        samplesize::Int64 = 50_000,
        cleanup::Bool = false,
        saveas::String = "database.h5",
        OMMIN::Float64 = 50.0,
        OMMAX::Float64 = 10000.0,
        override::Bool = false
    )

Creates a custom database by generating a number `repeats` of samples
of `samplesize` rows. Inputs for `runradcalinput` are to be generated
by a `sampler!` user-defined function which modifies in place an array
of compositions, and returns `T`, `L`, `P`, `FV`, `TWALL` for setting
up a simulation. Files are temporarilly stored under `data/` with a
sequential numbered naming during database creation and aggregated
in a HDF5 file named after `saveas`. The choice to aggregate files
after an initial dump is because generation can be interrupted and
manually recovered in an easier way and avoiding any risk of data
losses - database creation can take a very long time. If `cleanup` is
`true`, all intermediate files are removed.
"""
function createcustomdatabase(;
        sampler!::Function,
        repeats::Int64 = 100,
        samplesize::Int64 = 50_000,
        cleanup::Bool = false,
        saveas::String = "database.h5",
        OMMIN::Float64 = 50.0,
        OMMAX::Float64 = 10000.0,
        override::Bool = false
    )
    if isfile(saveas) && !override
        @warn ("Database $(saveas) already exists.")
        return
    end

    X = zeros(14)
    table = zeros(samplesize, 26)

    !isdir("tmp") && mkdir("tmp")
    fs = open("tmp/tmp.csv", "a")

    for fnum in 1:repeats
        for k in 1:samplesize
            T, L, P, FV, TWALL = sampler!(X)

            try
                result = runradcalinput(;
                    X = X,
                    T = T,
                    L = L,
                    P = P,
                    FV = FV,
                    TWALL = TWALL,
                    OMMIN = OMMIN,
                    OMMAX = OMMAX
                )

                table[k, 1:end] = result
            catch e
                println(e)
            end
        end

        fname = "tmp/block$(fnum).csv"
        writedlm(fname,  table, ',')
        write(fs, read(fname))
    end

    close(fs)

    h5open(saveas, "w") do fid
        data = readdlm("tmp/tmp.csv", ',', Float32)
        g = create_group(fid, "data")
        dset = create_dataset(g, "table", Float32, size(data))
        write(dset, data)
    end

    rm("RADCAL.IN")
    rm("RADCAL.OUT")
    rm("TRANS_CASE.TEC")

    if cleanup
        rm("tmp/"; force = true, recursive = true)
    end
end

"""
    loaddatabase(fname::String)

Retrieve database from HDF5 file and access table as a matrix.
"""
function loaddatabase(fname::String)
    h5open(fname, "r") do fid
        return read(fid["data"]["table"])
    end
end

##############################################################################
# Data sampler
##############################################################################

"""
    datasampler!(X::Vector{Float64})::Tuple

Custom sample space to generate entries with `createcustomdatabase`. This
function contains the parameter space used for model training.
"""
function datasampler!(X::Vector{Float64})::Tuple
    X[1] = rand(0.0:0.01:0.25)
    X[2] = rand(0.0:0.01:0.30)
    X[3] = rand(0.0:0.01:0.20)
    X[end] = 1.0 - sum(X[1:3])

    T = rand(300.0:10.0:2500.0)
    L = rand(0.1:0.1:3.0)
    P = rand(0.5:0.5:1.5)
    FV = 0.0
    TWALL = rand(300.0:10.0:2500.0)

    return T, L, P, FV, TWALL
end

##############################################################################
# Modeling
##############################################################################

# Do not even bother working without a GPU
# @assert CUDA.functional()

# Set graphics backend.
gr()

# Type aliases for non-default types.
M32 = Matrix{Float32}
V32 = Vector{Float32}

"""
    ModelData(fpath::String; f_train::Float64 = 0.7)

Load HDF5 database stored under `fpath` and performs standardized workflow
of data preparation for model training. The data is split under training and
testing datasets with a fraction of training data of `f_train`.

$(TYPEDFIELDS)
"""
struct ModelData
    "Scaler used for data transformation."
    scaler::ZScoreTransform{Float32,V32}

    "Matrix of training input data."
    X_train::M32

    "Matrix of training output data."
    Y_train::M32

    "Matrix of testing input data."
    X_tests::M32

    "Matrix of testing output data."
    Y_tests::M32

    "Number of model inputs."
    n_inputs::Int64

    "Number of model outputs."
    n_outputs::Int64

    function ModelData(fpath::String; f_train::Float64 = 0.7)
        # Read database and drop eventual duplicates.
        data = unique(loaddatabase(fpath), dims=1)

        # Index of predictors X and targets Y.
        X_cols = [3, 4, 5, 6, 8, 9, 10]
        Y_cols = [24, 26]

        # Compute index at which data must be split.
        split = (f_train * size(data)[1] |> round |> x -> convert(Int64, x))

        # Perform train-test split.
        train, tests = data[1:split, 1:end], data[split+1:end, 1:end]

        # Get matrices for predictors and targets.
        X_train, Y_train = train[1:end, X_cols], train[1:end, Y_cols]
        X_tests, Y_tests = tests[1:end, X_cols], tests[1:end, Y_cols]

        # Frameworks expected entries per column.
        X_train, Y_train = transpose(X_train), transpose(Y_train)
        X_tests, Y_tests = transpose(X_tests), transpose(Y_tests)

        # Apply standard scaling to data.
        scaler = fit(ZScoreTransform, X_train, dims=2)
        X_train = StatsBase.transform(scaler, X_train)
        X_tests = StatsBase.transform(scaler, X_tests)

        return new(scaler, X_train, Y_train, X_tests, Y_tests,
                   length(X_cols), length(Y_cols))
    end
end

"""
    ModelTrainer(
        data::ModelData,
        model::Chain;
        batch::Int64=64,
        epochs::Int64=100,
        η::Float64=0.001,
        β::Tuple{Float64,Float64}=(0.9, 0.999),
        ϵ::Float64=1.0e-08
    )

Holds standardized model training parameters and data.

$(TYPEDFIELDS)
"""
struct ModelTrainer
    "Batch size in training loop."
    batch::Int64

    "Number of epochs to train each time."
    epochs::Int64

    "Database structure used for training/testing."
    data::ModelData

    "Multi-layer perceptron used for modeling."
    model::Chain

    "Internal Adam optimizer."
    optim::NamedTuple

    "History of losses."
    losses::V32

    function ModelTrainer(
        data::ModelData,
        model::Chain;
        batch::Int64=64,
        epochs::Int64=100,
        η::Float64=0.001,
        β::Tuple{Float64,Float64}=(0.9, 0.999),
        ϵ::Float64=1.0e-08
    )
        model = model |> gpu
        optim = Flux.setup(Flux.Adam(η, β, ϵ), model)
        new(batch, epochs, data, model, optim, Float32[])
    end
end

"""
    dumpscaler(scaler::ZScoreTransform{Float32,V32}, saveas::String)

Write z-score `scaler` mean and scale to provided `saveas` YAML file.
"""
function dumpscaler(scaler::ZScoreTransform{Float32,V32}, saveas::String)
    data = Dict("mean" => scaler.mean, "scale" => scaler.scale)
    YAML.write_file(saveas, data)
end

"""
    loadscaler(fname::String)::Function

Load z-scaler in functional format from YAML `fname` file.
"""
function loadscaler(fname::String)::Function
    scaler = YAML.load_file(fname)
    μ = convert(Vector{Float32}, scaler["mean"])
    σ = convert(Vector{Float32}, scaler["scale"])
    return (x -> @. (x - μ) / σ)
end

"""
    makemodel(layers::Vector{Tuple{Int64, Any}}; bn = false)::Chain

Create a multi-layer perceptron for learning radiative properties
with the provided `layers`. If `bn` is true, then batch normalization
after each layer. The final layer has by default a sigmoid function
to ensure physical outputs in range [0, 1].
"""
function makemodel(layers::Vector{Tuple{Int64, Any}}; bn = false)::Chain
    chained = []

    for (a, b) in zip(layers[1:end-1], layers[2:end])
        push!(chained, Dense(a[1] => b[1], a[2]))
        if bn
            push!(chained, BatchNorm(b[1]))
        end
    end

    return Chain(chained..., sigmoid)
end

"""
    defaultmodel()

Build model structure with which RadCalNet is trained.
"""
function defaultmodel()
    return makemodel([
        (7,   identity),
        (100, leakyrelu),
        (50,  leakyrelu),
        (20,  leakyrelu),
        (20,  leakyrelu),
        (10,  leakyrelu),
        (10,  leakyrelu),
        (5,   leakyrelu),
        (2,   ())
    ])
end

""" Get sample of indexes for data retrieval.  """
function samplecols(nmax::Int64, num::Int64)::Vector{Int64}
  return rand(1:nmax, min(num, nmax))
end

""" Get training data for data loader construction. """
function train(data::ModelData, num::Int64)::Tuple{M32,M32}
    cols = samplecols(size(data.X_train)[2], num)
    return (data.X_train[:, cols], data.Y_train[:, cols])
end

""" Get testing data for data loader construction. """
function tests(data::ModelData, num::Int64)::Tuple{M32,M32}
  cols = samplecols(size(data.X_tests)[2], num)
  return (data.X_tests[:, cols], data.Y_tests[:, cols])
end

"""
    trainonce!(trainer::ModelTrainer; num = 1_000)

Train model and keep track of loss for the number of epochs in `trainer`
using its internal data and parameters. Use `num` data points.
"""
function trainonce!(trainer::ModelTrainer; num = 1_000)::V32
    loader = Flux.DataLoader(train(trainer.data, num) |> gpu,
                             batchsize=trainer.batch, shuffle=false)

    @showprogress for _ in 1:trainer.epochs
        for (x, y) in loader
            loss, grads = Flux.withgradient(trainer.model) do m
                Flux.mse(m(x), y)
            end
            Flux.update!(trainer.optim, trainer.model, grads[1])
            push!(trainer.losses, loss)
        end
    end

    return trainer.losses
end

"""
    plottests(trainer::ModelTrainer; num::Int64)

Evaluate model over `num` data points and compare the data to
the expected values as computed from RadCal. Makes use of test
data only - never seem by the model during training.
"""
function plottests(trainer::ModelTrainer; num::Int64)
    X_tests, Y_tests = tests(trainer.data, num)
    Y_preds = trainer.model(X_tests |> gpu) |> cpu

    εt, εp = Y_tests[1, :], Y_preds[1, :]
    τt, τp = Y_tests[2, :], Y_preds[2, :]

    εlims = [0.0, 0.5]
    τlims = [0.0, 1.0]

    l = @layout [a b]

    pε = scatter(εt, εp, xlims=εlims, ylims=εlims,
                 xlabel="ε from RadCal",
                 ylabel="ε from neural network",
                 label=nothing,
                 markerstrokewidth=0.0,
                 markeralpha=0.5,
                 markercolor="#000000")

    pτ = scatter(τt, τp, xlims=τlims, ylims=τlims,
                 xlabel="τ from RadCal",
                 ylabel="τ from neural network",
                 label=nothing,
                 markerstrokewidth=0.0,
                 markeralpha=0.5,
                 markercolor="#000000")

    plot!(pε, εlims, εlims, color="#FF0000", label=nothing)
    plot!(pτ, τlims, τlims, color="#FF0000", label=nothing)

    return plot(pε, pτ, layout=l, size=(1200, 600),
                margin=5Plots.mm)
end

##############################################################################
# Main
##############################################################################

"""
    getradcalnet(;
        scale = true,
        fscaler = nothing,
        fmstate = nothing
    )

Load trained model and scaler to compose RadCalNet. If testing new
models, it might be useful to use `fscaler` and `fmstate` to point
to specific versions of scaler and model state files.
"""
function getradcalnet(;
        scale = true,
        fscaler = nothing,
        fmstate = nothing
    )
    fscaler = isnothing(fscaler) ? FILESCALER : fscaler
    fmstate = isnothing(fmstate) ? FILEMODEL  : fmstate

    model = defaultmodel()
    scaler = (scale) ? loadscaler(fscaler) : identity
    mstate = JLD2.load(fmstate, "model_state")
    Flux.loadmodel!(model, mstate)

    return (x -> x |> scaler |> model)
end

""" 
    model(x::Vector{Float32})::Vector{Float32}

Main model interface for emissivity and transmissivity.
"""
const model = getradcalnet()

end # (module RadCalNet)
