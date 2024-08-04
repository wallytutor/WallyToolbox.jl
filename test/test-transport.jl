# -*- coding: utf-8 -*-

@testset "transport" begin
    nu_gn = NusseltGnielinski()
    nu_db = NusseltDittusBoelter()

    aspect_ratio = 100.0
    validate = true

    @test_throws ArgumentError nusselt(nu_gn, 5.0e+07, 0.7; validate)

    @test_throws ArgumentError nusselt(nu_gn, 5.0e+03, 0.4; validate)

    @test_throws ArgumentError nusselt(nu_gn, 5.0e+07, 0.4; validate)

    @test_throws ArgumentError nusselt(nu_db, 5.0e+03, 0.7; validate, aspect_ratio)

    @test_throws ArgumentError nusselt(nu_db, 5.0e+04, 0.5; validate, aspect_ratio)

    @test_throws ArgumentError nusselt(nu_db, 5.0e+04, 0.7; validate, aspect_ratio = 1.0)
end
