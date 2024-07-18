# A simple random walker

```julia; @example notebook
using CairoMakie
using Random
using SpecialFunctions
nothing; #hide
```

```julia; @example notebook
# Create a random number generator with a given seed.
rng = MersenneTwister(42)

# Probility of moving a distance y, step size K.
p(z, K) = exp(-z / K)

# Characteristic maximum step.
K = 2

# Size of square domain (matrix) for random walks.
n = 50

# If N > n, then *neighbors* interact!
# Number of random walk steps to perform.
N = 3n

# Number of repeats for sampling
M = 10_000
nothing; #hide
```

```julia; @example notebook
# Allocate matrix for tracking presence history.
A = zeros(Int64, (n, n))

# Get initial position of *particle*.
# xn, yn = rand(rng, 0:n-1, 2)
xn, yn = div(n, 2), div(n, 2)

# Store initial position for display later.
x0, y0 = xn, yn

# Start sampling loop.
for rm ∈ 1:M
    # Reinitialize particle position.
    xn, yn = x0, y0

    # NO: Feed particle to its initial position.
    # The initial particle is *outside* the domain!
    # A[xn+1, yn+1] += 1

    # Start random-walk loop.
    for tn ∈ 1:N
        # Sample the distance to try to move.
        Δx, Δy = rand(rng, -K:K, 2)

        # Compute new hypothetical position.
        xm = mod(xn + Δx, n)
        ym = mod(yn + Δy, n)

        # Compute distance from current point.
        z = hypot(xn-xm, yn-ym)

        # Take shot on current movement.
        bullet = rand(rng)
        threshold = p(z, K)

        # Always move or should I use RNG?
        # if true #bullet < threshold
        if bullet < threshold
            # global xn, yn, A

            # Make sure wrapping around is respected.
            xm = (xm>0) ? xm : n-xm
            ym = (ym>0) ? ym : n-ym

            # Update position.
            xn, yn = xm, ym
            A[xn, yn] += 1
        end
    end
end

with_theme() do
    nn = div(n, 2) + 1
    
    a1 = reshape(sum(A; dims=1), n)[nn:end]
    a2 = reshape(sum(A; dims=2), n)[nn:end]

    a1 /= sum(a1)
    a2 /= sum(a2)

    a1 /= maximum(a1)
    a2 /= maximum(a2)

    # This is obviously wrong!
    x = 1:nn
    t = N
    D = K / 6 # HOW SHOULD I? (Meher, 2007)
    C = 1.0
    
    # Constant surface concentration solution:
    an = @. C * erfc(x/(2sqrt(D*t)))
    
    f = Figure(size = (1000, 500))
    
    ax1 = Axis(f[1, 1]; aspect = 1)
    heatmap!(ax1, A; colormap = :thermal)
    scatter!(ax1, x0, y0; color = :red)

    ax2 = Axis(f[1, 2]; aspect = 1)
    lines!(ax2, a1; color=:black)
    lines!(ax2, a2; color=:red)
    lines!(ax2, an; color=:blue) 
    xlims!(ax2, 0, nn)
    ylims!(ax2, 0, 1.5)
    
    f
end
```
