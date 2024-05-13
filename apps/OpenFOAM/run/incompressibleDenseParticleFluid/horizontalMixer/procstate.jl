#!/usr/bin/env julia
using LightXML
using NaturalSort

# Constants identified in first file of `000/`.
const PID1 = "11907"
const PID2 = "12150"
const ORIG = "../000/state.xml"

function getvtkfiles(dirname)
    files = readdir(dirname)
    files = filter(n->endswith(n, ".vtk"), files)
    files = sort(files, lt=natural)
    return joinpath.(dirname, files)
end

function getvtktags(dirname, formatter)
    files = getvtkfiles(dirname)
    tags = join([formatter(k, f) for (k, f) in enumerate(files)], "\n")
    return tags
end

function filterattr(proxy, attr, value)
    return attribute(proxy, attr) == value
end

function proxyfilter(proxy, pid)
    test1 = filterattr(proxy, "group", "sources")
    test2 = filterattr(proxy, "id", pid)
    return test1 && test2
end

findpid(proxies, pid) = filter(p->proxyfilter(p, pid), proxies)[1]
findfni(props) = filter(p->filterattr(p, "name", "FileNameInfo"), props)[1]
findfns(props) = filter(p->filterattr(p, "name", "FileNames"), props)[1]

function processpid(proxies, pidn, files)
    pid = findpid(proxies, pidn)
    fni = findfni(pid["Property"])
    fns = findfns(pid["Property"])

    set_attributes(fni["Element"][1], value=files[1])

    # XXX: error if not same length for safety!
    for (e, fname) in zip(fns["Element"], files)
        set_attributes(e, value=fname)
    end
end

function workflow(case; saveas = "state.pvsm")
    cd(case)

    @info "Working from $(pwd())"

    # Parse file and get root.
    xdoc = parse_file(ORIG)
    xroot = root(xdoc)

    # Ensure data was processed.
    !isdir("VTK")&& run(`foamToVTK`)

    # Path of VTK files.
    eulerian = joinpath(pwd(), "VTK/")
    lagrangian = joinpath(eulerian, "lagrangian/cloud/")
    
    # Get and manipulate Proxy entries.
    proxies = xroot["ServerManagerState"][1]["Proxy"]
    processpid(proxies, PID1, getvtkfiles(eulerian))
    processpid(proxies, PID2, getvtkfiles(lagrangian))

    # Just fix as string the regexes.
    text = replace(string(xdoc), "000_*" => "$(case)_*")

    # Reparse as XML and dump.
    saveas = joinpath(pwd(), saveas)
    @info "Dumping results at $(saveas)"
    save_file(parse_string(text), saveas)

    # Open paraview for post-processing.
    try
        @info "Running ParaView"
        run(`paraview --state state.pvsm`)
    catch e
        @warn e
    end

    cd(@__DIR__)

    try
        @info "Trying to convert images to GIF"
        run(`convert -delay 10 -loop 0 "$(case)/animation/*.png" \
                 animation-$(case).gif`)
    catch e
        @warn e
    end

    return nothing
end

workflow("012")
