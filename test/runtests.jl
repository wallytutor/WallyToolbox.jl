# -*- coding: utf-8 -*-
using Test

@testset "DryTransport" begin

    nu_gn = NusseltGnielinski()
    nu_db = NusseltDittusBoelter()

    aspect_ratio = 100.0
    validate = true

    # try nusselt(nu_gn, 5.0e+07, 0.7; validate)                     catch end
    # try nusselt(nu_gn, 5.0e+03, 0.4; validate)                     catch end
    # try nusselt(nu_gn, 5.0e+07, 0.4; validate)                     catch end
    # try nusselt(nu_db, 5.0e+03, 0.7; validate, aspect_ratio)       catch end
    # try nusselt(nu_db, 5.0e+04, 0.5; validate, aspect_ratio)       catch end
    # try nusselt(nu_db, 5.0e+04, 0.7; validate, aspect_ratio = 1.0) catch end
end