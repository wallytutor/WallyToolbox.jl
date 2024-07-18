# A simple random walker

```julia
using CairoMakie
using Random
using SpecialFunctions
nothing; #hide
```

```julia
# Create a random number generator with a given seed.
const RNG = MersenneTwister(42)
nothing; #hide
```

```julia
function random_walker(p, n, N, K, xn, yn, A)
    for tn ∈ 1:N
        # Sample the distance to try to move.
        Δx, Δy = rand(RNG, -K:K, 2)

        # Compute new hypothetical position.
        xm = mod(xn + Δx, n)
        ym = mod(yn + Δy, n)

        # Compute distance from current point.
        z = hypot(xn - xm, yn - ym)

        # Take shot on current movement.
        bullet = rand(RNG)
        threshold = p(z, K)

        # Always move or should I use RNG?
        # if true #bullet < threshold
        if bullet < threshold
            # FIXME: last r/c is being skipped!
            # Make sure wrapping around is respected.
            xm = (1 <= xm <= n) ? xm : n+xm
            ym = (1 <= ym <= n) ? ym : n+ym
            # xm = (xm>0) ? xm : n+xm-1
            # ym = (ym>0) ? ym : n+ym-1

            # Update position.
            xn, yn = xm, ym
            A[xn, yn] += 1
        end
    end
end
```

```julia
function simulation(N, M, n, p, K)
    # Allocate matrix for tracking presence history.
    A = zeros(Int64, (n, n))
    
    # Get initial position of *particle*.
    xn, yn = rand(RNG, 1:n, 2)
    # xn, yn = div(n, 2), div(n, 2)
    
    # Store initial position for display later.
    x0, y0 = xn, yn
    
    # Start sampling loop.
    for rm ∈ 1:M
        # NO: Feed particle to its initial position.
        # The initial particle is *outside* the domain!
        # A[xn+1, yn+1] += 1
    
        # Start random-walk loop.
        random_walker(p, n, N, K, xn, yn, A)
    
        # Reinitialize particle position.
        xn, yn = x0, y0
    end

    return A
end
```

```julia
function workflow(p, K, n, N, M)
    A = simulation(N, M, n, p, K)
    
    with_theme() do
        n = first(size(A))
        nn = div(n, 2) + 1
        
        a1 = reshape(sum(A; dims=1), n)[nn:end-1]
        a2 = reshape(sum(A; dims=2), n)[nn:end-1]
    
        a1 /= sum(a1)
        a2 /= sum(a2)
    
        a1 /= maximum(a1)
        a2 /= maximum(a2)
    
        # This is obviously wrong!
        # x = 1:nn
        # t = N
        # D = K / 6 # HOW SHOULD I? (Meher, 2007)
        # C = 1.0
        # Constant surface concentration solution:
        # an = @. C * erfc(x/(2sqrt(D*t)))
        
        f = Figure(size = (1000, 500))
        
        ax1 = Axis(f[1, 1]; aspect = 1)
        heatmap!(ax1, A[1:end-1, 1:end-1]; colormap = :thermal)
    
        ax2 = Axis(f[1, 2]; aspect = 1)
        lines!(ax2, a1; color=:black)
        lines!(ax2, a2; color=:red)
        # lines!(ax2, an; color=:blue) 
        xlims!(ax2, 0, nn)
        ylims!(ax2, 0, 1.5)
        
        f
    end
end
```

```julia
let
    # Probility of moving a distance y, step size K.
    p(z, K) = exp(-z / K)
    
    # Characteristic maximum step.
    K = 2
    
    # Size of square domain (matrix) for random walks.
    n = 50
    
    # If N > n, then *neighbors* interact!
    # Number of random walk steps to perform.
    N = 5n
    
    # Number of repeats for sampling
    M = 1000

    workflow(p, K, n, N, M)
end
```

```julia
n = 50

istrue = true

for _n in 1:10
    for _ in 1:20
        x = rand(RNG, -(n-1):n)
        v = (1 <= n+x <= n) ? n+x : x
        
        if (v == 0) || (v > n)
            println(x, " ", v)
        end
    
        if !(1 <= v <= n)
            println("WTH: $(v)")
        end
            
        istrue = istrue && (1 <= v <= n)
    end
end

istrue
```

```julia

```

```julia

```
