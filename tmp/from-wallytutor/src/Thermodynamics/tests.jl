# -*- coding: utf-8 -*-
using DryTooling

@testset "Shomate material" begin
    # Webbook NIST ID=C14808607&Type=JANAF&Table=on
    silica = dry.MaterialShomate(
        a_lo = [-6.076591, 251.6755, -324.7964, 168.5604,
                0.002548, -917.6893, -27.96962, -910.8568],
        a_hi = [58.7534, 10.27925, -0.131384, 0.02521,
                0.025601, -929.3292, 105.8092, -910.8568],
        T_ch = 847.0
    )
    T = [298.0, 300.0, 400.0, 847.0, 900.0, 1900.0]
    c = [44.57, 44.77, 53.43, 67.42, 67.95, 77.99]
    @test sum(abs2, silica.cₚ.(T) - c) < 0.0001
end
