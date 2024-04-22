# -*- coding: utf-8 -*-
using GLMakie
using ProgressMeter
using Random

# Probility of moving a distance y.
p(z) = exp(-z / 3)

# Create a random number generator with a given seed.
rng = MersenneTwister(42)

# Size of square domain (matrix) for random walks.
n = 20

# Number of random walk steps to perform.
N = 1_000_000

# Maximum number of tries for performing a step.
max_tries = 100

# Maximum fraction of fails at performing a step.
max_fails = 0.01

# Allocate matrix for tracking presence history.
A = zeros(Int64, (n, n))

# Get initial position of *particle*.
xn, yn = rand(rng, 1:n, 2)
x0, y0 = xn, yn

# Feed particle to its initial position.
A[xn, yn] += 1

frozen = 0

@showprogress for tn ∈ 1:N
    n_try = 0

    while n_try < max_tries
        n_try += 1

        xm, ym = rand(rng, 1:n, 2)
        
        # TODO: consider the system wraps around!
        z = hypot((xn-xm), (yn-ym))

        bullet = rand()

        threshold = p(z)

        if bullet < threshold
            xn, yn = xm, ym
            A[xn, yn] += 1
            break
        end
    end

    if n_try == max_tries
        frozen += 1
    end
end

if frozen > max_fails * N
    @error("Missed too many steps: $(frozen) of $(N)")
end

B = A / sum(A)

fig = with_theme() do
    f = Figure()
    ax = Axis(f[1, 1])
    
    heatmap!(ax, B; colormap = :thermal)
    scatter!(ax, x0, y0; color = :black)
    f
end

save("test.png", fig)
