# -*- coding: utf-8 -*-
module WallyDocuments

using Documenter
using Documenter.DocMeta: setdocmeta!
using Documenter.HTMLWriter: relhref

export get_format, deployrepo, julianizemarkdown
export formatnotecells, formatequations

DEBUGMATCHES  = false

# See https://stackoverflow.com/questions/20478823/
macro p_str(s) s end

ANYNAME = p"(?<named>((.|\n)*?))"

OJULIA  = p"(```julia;(\s+)@example(\s+)(.*)\n)"
CJULIA  = p"(\n```)"
SJULIA  = s"```@example notebook\n\g<named>\n```"

ODOLLAR = p"(\$\$((\s+|\n)?))"
CDOLLAR = p"(((\s+|\n)?)\$\$)"
SDOLLAR = s"```math\n\g<named>\n```"


"Get format specified to generate docs."
function get_format(; latex = false, user, sitename)
    if (latex)
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
        size_threshold_warn = 1_000_000,
        size_threshold = 2_000_000,
        example_size_threshold = 2_000_000
    )

    return format
end

"Generate a `repo` argument in the format expected by `deploydocs`."
deployrepo(format) = last(split(format.repolink, "://")) * ".git"

"Convert equations from dollar to Julia ticks notation."
function julianizemarkdown(;
        formatter::Function,
        spath::String,
        wpath::String,
        ignores::Vector{String} = [".gitignore", ".obsidian"]
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

"Helper to debug regex matches by simply printing to the screen."
function matchdebugger(gr, text)
    if (m = match(gr, text); m !== nothing)
        println(m[:named])
    end
end

"Convert cells of notebooks to Documenter format."
function formatnotecells(text)
    oldgroup = Regex(join([OJULIA, ANYNAME, CJULIA]))
    DEBUGMATCHES && matchdebugger(oldgroup, text)
    return replace(text, oldgroup => SJULIA)
end

"Convert (multiline) equations to Julia markdown."
function formatequations(text)
    oldgroup = Regex(join([ODOLLAR, ANYNAME, CDOLLAR]))
    DEBUGMATCHES && matchdebugger(oldgroup, text)
    return replace(text, oldgroup => SDOLLAR)
end

end # (module WallyDocuments)