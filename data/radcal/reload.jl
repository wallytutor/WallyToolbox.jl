# -*- coding: utf-8 -*-
using Flux: mae
using RadCalNet: ModelData, tests
import RadCalNet
import Random

# Provide a seed at start-up for *maybe* reproducible builds.
Random.seed!(42)

# Test with any user-provided array (Float32!).
x = Float32[1200.0; 1000.0; 2.0; 1.0; 0.1; 0.2; 0.1]
y = RadCalNet.model(x)

# Load database for running test cases.
radcal = RadCalNet.getradcalnet(scale = false)
data = ModelData("$(@__DIR__)/database.h5")
err = tests(data, 2_000_000) |> a->mae(radcal(a[1]), a[2])
