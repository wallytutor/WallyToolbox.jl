# -*- coding: utf-8 -*-
using GLMakie
using ProgressMeter
using Random

# Probility of moving a distance y.
p(z, K) = exp(-z / K)

# Create a random number generator with a given seed.
rng = MersenneTwister(42)

# Size of square domain (matrix) for random walks.
n = 100

# Number of random walk steps to perform.
N = 1_000

# Maximum step size.
K = 2

# Maximum number of tries for performing a step.
max_tries = 100

# Maximum fraction of fails at performing a step.
max_fails = 0.01

# Allocate matrix for tracking presence history.
A = zeros(Int64, (n, n))

# Get initial position of *particle*.
xn, yn = rand(rng, 0:n-1, 2)

# Store initial position for display later.
x0, y0 = xn, yn

# Feed particle to its initial position.
A[xn+1, yn+1] += 1

# Tracker for number of misses.
frozen = 0

# Initialize figure.
# fig, ax, hm = heatmap(A / N; colormap = :thermal)#, colorrange = (0.0, N/n))
# scatter!(ax, x0, y0; color = :black)

saveas = joinpath(@__DIR__, "random-walk.mp4")

@showprogress for tn ∈ 1:N
# record(fig, saveas, 1:N) do tn
    # global xn, yn, A, frozen
    
    n_try = 0

    while n_try < max_tries
        n_try += 1

        # TODO: system wraps around! Not fully working if we still use clamp!
        Δx, Δy = rand(rng, -K:K, 2)
        xm = mod(xn + Δx, n)
        ym = mod(yn + Δy, n)

        z = hypot(xn-xm, yn-ym)

        bullet = rand()
        threshold = p(z, K)

        if bullet < threshold
            xn, yn = xm, ym
            A[xn+1, yn+1] += 1
            break
        end
    end

    # hm[3].val = A / N

    if n_try == max_tries
        frozen += 1
    end
end

# hm[3].val = A / sum(A)

if frozen > max_fails * N
    @error("Missed too many steps: $(frozen) of $(N)")
end

fig = with_theme() do
    f = Figure()
    ax = Axis(f[1, 1])
    
    heatmap!(ax, A / N; colormap = :thermal)
    scatter!(ax, x0, y0; color = :black)
    f
end

save("test.png", fig)
