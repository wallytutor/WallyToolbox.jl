# -*- coding: utf-8 -*-
module Notebook

using IJulia
using JSON
using Pkg
using Pluto

export launch_notebook, launch_jupyterlab, launch_pluto

function ensure_jupyter_data()
    jupyter_dir = get(ENV, "JUPYTER_DATA_DIR", nothing)

    if isnothing(jupyter_dir)
        @error("Variabel `JUPYTER_DATA_DIR` must be user-defined!")
        exit(-1)
    end

    return abspath(jupyter_dir)
end

function get_kernel_file()
    jupyter_dir = ensure_jupyter_data()
    kernel_dir  = joinpath(jupyter_dir, "kernels", "wnote")
    kernel_file = joinpath(kernel_dir, "kernel.json")

    if !isdir(kernel_dir)
        @info("Creating required kernel path at $(kernel_dir)")
        mkpath(kernel_dir)
    end

    return kernel_file
end

function get_kernel_spec()
    # XXX: current_project does not seem to be the reliable choice here,
    # it is based on the first Project.toml found in path. Check it!
    # if isnothing(Base.current_project())
    #     throw(ErrorException("Must be called from an active project"))
    # end

    julia_path    = joinpath(Sys.BINDIR, "julia")
    project_path  = dirname(Base.active_project())
    ijulia_kernel = joinpath(dirname(pathof(IJulia)), "kernel.jl")
    
    kernel_spec = Dict(
        "display_name" => "WallyTutor Julia",
        "argv" => [
            julia_path,
            "-i",
            "--color=yes",
            "--project=$(project_path)",
            ijulia_kernel,
            "{connection_file}"
        ],
        "language" => "julia",
        "env" => Dict(),
        "interrupt_mode" => "message"
    )
    
    return kernel_spec
end

function dump_kernel_spec()
    kernel_file = get_kernel_file()

    if isfile(kernel_file)
        @info("Nothing to do, kernel exists at $(kernel_file)")
        return nothing
    end
    
    open(kernel_file, "w") do f
        JSON.print(f, get_kernel_spec(), 2)
    end
end

"Launch Jupyter notebook session with WallyToolbox kernel."
function launch_notebook(; detached = true)
    dump_kernel_spec()
    notebook(; dir=pwd(), detached)
end

"Launch Jupyterlab session with WallyToolbox kernel."
function launch_jupyterlab(; detached = true)
    dump_kernel_spec()
    jupyterlab(; dir=pwd(), detached)
end

"Launch a Pluto notebook session with a template notebook."
function launch_pluto(;
        browser = false,
        port = 2505,
        autoreload = true,
        capture_stdout = true
    )
    if !haskey(ENV, "WALLYROOT")
        @error("""\
            Running `launch_pluto` assumes you have a properly set \
            WallyToolbox environment. Please make sure that environment \
            variable `WALLYROOT` points to WallyToolbox.jl project root \
            directory. Trying to start anyways...
        """)
    end

    # Get and ensure `pluto_notebooks` directory:
    conf_dir = joinpath(ENV["JULIA_DEPOT_PATH"], "pluto_notebooks")
    !isdir(conf_dir) && mkdir(conf_dir)

    # Copy latest version of template file to conf_dir:
    pluto_init = joinpath(@__DIR__, "pluto_init.jl")
    pluto_temp = joinpath(conf_dir, "template.jl")
    cp(pluto_init, pluto_temp)

    session = Pluto.ServerSession()
    session.options.server.launch_browser = browser
    session.options.server.port = port
    session.options.server.root_url = "http://127.0.0.1:$(port)/"
    session.options.server.auto_reload_from_file = autoreload
    session.options.evaluation.capture_stdout = capture_stdout
    session.options.server.notebook = pluto_temp

    Pluto.run(session)

    @info("Closing Pluto session, cleaning up...")
    rm(pluto_temp)
end

end # (Notebook)
