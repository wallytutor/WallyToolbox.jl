# -*- coding: utf-8 -*-

# For now do not throw an error because otherwise the documentation build
# will fail. Find a way of getting Cantera working on workflow.
if !haskey(ENV, "CANTERA_SHARED")
    @warn "CANTERA_SHARED environment variable required"
    # error("CANTERA_SHARED environment variable required")
    const CANTERA = nothing
else
    const CANTERA = Libdl.dlopen(ENV["CANTERA_SHARED"])
end

struct FnShared
   ptr::Ptr{Nothing}
   name::String

   function FnShared(name)
       # Handle the missing library for documentation generation.
       if isnothing(CANTERA)
           return new()
       end
       return new(Libdl.dlsym(CANTERA, name), string(name))
   end
end