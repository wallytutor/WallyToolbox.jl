# -*- coding: utf-8 -*-
import Pkg
using Revise

if Base.current_project() != Base.active_project()
    Pkg.activate(Base.current_project())
    Pkg.resolve()
    Pkg.instantiate()
end

include("common.jl")
