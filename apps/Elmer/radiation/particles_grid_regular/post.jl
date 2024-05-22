# -*- coding: utf-8 -*-
using DelimitedFiles
using Statistics

data = readdlm("bflux.dat")

Th = 1300
R = 100e-06

Ly = maximum(data[:, 5])
Lx = mean(data[:, 4])

As = 15π*R^2
At = Lx * Ly

ϕ = As / At

qx = mean(data[:, end])
Tc = mean(data[:, 7])

k = -1 * qx * Lx / (Th - Tc)