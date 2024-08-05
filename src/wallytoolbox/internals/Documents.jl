# -*- coding: utf-8 -*-
module Documents

using Documenter
using Documenter.DocMeta: setdocmeta!
using Documenter.HTMLWriter: relhref
using JuliaFormatter
using Pluto: ServerSession, SessionActions
using Pluto: generate_html

export deployrepo
export setdocmetawrapper!
export get_format
export julianizemarkdown
export formatnotecells
export formatequations
export formatembvideos
export formatembimages
export convert_pluto

DEBUGMATCHES  = false

# See https://stackoverflow.com/questions/20478823/
macro p_str(s) s end

const ANYNAME = p"(?<named>((.|\n)*?))"

const OJULIA  = p"(```julia;(\s+)@example(\s+)(.*)\n)"
const CJULIA  = p"(\n```)"
const SJULIA  = s"```@example notebook\n\g<named>\n```"

const ODOLLAR = p"(\$\$((\s+|\n)?))"
const CDOLLAR = p"(((\s+|\n)?)\$\$)"
const SDOLLAR = s"```math\n\g<named>\n```"

const OIMAGE  = p"!\[@image\]\("
const OVIDEO  = p"!\[@video\]\("

const CMEDIA  = p"\)"
const SMEDIA  = s"""
    ```@raw html
    <center>
      <iframe width="500" style="height:315px" frameborder="0"
              src="\g<named>" allowfullscreen>
      </iframe>
    </center>
    ```
    """

"Generate a `repo` argument in the format expected by `deploydocs`."
deployrepo(format) = last(split(format.repolink, "://")) * ".git"

"Simple wrapper to set documentation tests metadata."
function setdocmetawrapper!(m; warn = false, recursive = true)
    setdocmeta!(m, :DocTestSetup, :(using $(Symbol(m))); warn, recursive)
end

"Get format specified to generate docs."
function get_format(user, sitename; kw...)
    if get(kw, :latex, false)
        # TODO add automatic tectonic download here!
        return Documenter.LaTeX(;
            platform = "tectonic",
            tectonic = joinpath(@__DIR__, "tectonic.exe")
        )
    end

    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical  = "https://$(user).github.io/$(sitename)",
        repolink   = "https://github.com/$(user)/$(sitename)",
        edit_link  = "main",
        assets     = String[],
        size_threshold_warn    = 1_000_000,
        size_threshold         = 2_000_000,
        example_size_threshold = 2_000_000
    )

    return format
end

"Convert Pluto notebook into a static HTML file."
function convert_pluto(nblist::Vector{String};
        root=pwd(), distributed=true, force=false, verbose=2)

    s = ServerSession()
    s.options.server.launch_browser = false
    s.options.server.dismiss_update_notification = true
    s.options.server.disable_writing_notebook_files = true
    s.options.server.show_file_system = false
    s.options.evaluation.workspace_use_distributed = distributed

    for nbname in nblist
        nbpath = joinpath(root, "$(nbname).jl")
        pgpath = joinpath(root, "$(nbname).html")
        
        if !format_file(nbpath)
            @warn("file not formatted: $(nbpath)")
        end
        
        if isfile(pgpath) && !force
            verbose > 1 && @info("file exists: $(pgpath)")
            continue
        end
        
        verbose > 0 && @info "working on $(nbname)"
        nb = SessionActions.open(s, nbpath; run_async=false)
        write(pgpath, generate_html(nb))
        SessionActions.shutdown(s, nb)
    end
end

"Convert equations from dollar to Julia ticks notation."
function julianizemarkdown(;
        formatter::Function,
        spath::String,
        wpath::String,
        ignores::Vector{String} = [
            ".gitignore",
            ".obsidian",
            ".ipynb_checkpoints",
        ]
    )
    # Ensure directory exists.
    !isdir(wpath) && mkpath(wpath)

    # Remove basename of wpath plus "/../" pointing above it.
    cutl = length(splitpath(wpath)[end]) + 3 + 1 

    for (root, _, files) in walkdir(spath)
        for file in files
            # Absolute path of file in sources.
            apath = joinpath(root, file)

            # Relative path of file from source root.
            rpath = relpath(apath, spath)

            # Path for relative markdown links.
            rhpath = relhref(apath, wpath)[1:end-cutl]

            # Directories to ignore in search (in source roots only!).
            # Check if not in list of ignored paths.
            any(p->startswith(rpath, p), ignores) && continue

            # Destination path of processed file.
            dpath = joinpath(wpath, rpath)

            # Directory name of processed file.
            fpath = dirname(dpath)

            # Ensure directory exists.
            !isdir(fpath) && mkpath(fpath)

            # @info("Processing $(apath)")
            if endswith(file, ".md")
                content = open(apath) do io
                    formatter(read(io, String), rhpath)
                end
                open(dpath, "w") do io
                    write(io, content)
                end
            else
                cp(apath, dpath; force = true)
            end
        end
    end
end

function makeformat(text, tagopen, tagclose, tagnew;
                    tagmid = ANYNAME)
    oldgroup = Regex(join([tagopen, tagmid, tagclose]))

    DEBUGMATCHES && begin
        if (m = match(oldgroup, text); m !== nothing)
            println(m[:named])
        end
    end

    return replace(text, oldgroup => tagnew)
end

"Convert cells of notebooks to Documenter format."
formatnotecells(text) = makeformat(text, OJULIA, CJULIA, SJULIA)

"Convert (multiline) equations to Julia markdown."
formatequations(text) = makeformat(text, ODOLLAR, CDOLLAR, SDOLLAR)

"Convert simple embeded markdown image to raw HTML."
formatembimages(text) = makeformat(text, OIMAGE, CMEDIA, SMEDIA)

"Convert simple embeded markdown video to raw HTML."
formatembvideos(text) = makeformat(text, OVIDEO, CMEDIA, SMEDIA)

end # (module Documents)