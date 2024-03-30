# -*- coding: utf-8 -*-
using DryTooling
using DryTooling.FluidModels

@testset "Gas Phase Models" begin
    # @test begin
    #    selected = ["CH4", "O2", "CO2", "H2O", "N2"]
    #    gas = dry.IdealGasMixture(data, selected)
    #    M = gas.molecularmasses
    #    species = gas.species[end]

    #    Tnum = 1000.0
    #    @parameters Tsym
    #    @variables Tvar

    #    Ynum = ones(gas.nspecies) / gas.nspecies
    #    @parameters Ysym[1:gas.nspecies]

    #    gas.Y[1:end] = Ynum

    #    dry.specificheatmass(species, Tnum)
    #    dry.specificheatmass(species, Tsym)
    #    dry.specificheatmass(species, Tvar)

    #    dry.enthalpymass(species, Tnum)
    #    dry.enthalpymass(species, Tsym)
    #    dry.enthalpymass(species, Tvar)

    #    dry.specificheatmole(species, Tnum)
    #    dry.specificheatmole(species, Tsym)
    #    dry.specificheatmole(species, Tvar)

    #    dry.enthalpymole(species, Tnum)
    #    dry.enthalpymole(species, Tsym)
    #    dry.enthalpymole(species, Tvar)

    #    dry.meanmolecularmass(Ynum, M)
    #    dry.meanmolecularmass(Ysym, M)

    #    dry.massfraction2molefraction(Ynum, M)
    #    dry.massfraction2molefraction(Ysym, M)

    #    dry.molefraction2massfraction(Ynum, M)
    #    dry.molefraction2massfraction(Ysym, M)

    #    dry.meanmolecularmass(gas)
    #    dry.densitymass(gas)
    #    sum(dry.massfractions(gas)) ≈ 1.0
    #    sum(dry.molefractions(gas)) ≈ 1.0
    #    dry.specificheatmass(gas)
    # end
end
