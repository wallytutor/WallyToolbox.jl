# -*- coding: utf-8 -*-
module WallyNotebook
using Pkg
using IJulia
using JSON

export launch_notebook

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
    julia_path    = joinpath(Sys.BINDIR, "julia")
    project_path  = dirname(Base.current_project())
    ijulia_kernel = joinpath(dirname(pathof(IJulia)), "kernel.jl")
    
    kernel_spec = Dict(
        "display_name" => "WallyTutor Julia 1.10.4",
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

function launch_notebook()
    dump_kernel_spec()
    notebook(dir=pwd(), detached=true)
end

end # (WallyNotebook)
