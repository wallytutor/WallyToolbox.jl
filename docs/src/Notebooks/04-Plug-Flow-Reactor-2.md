# Formulação entálpica do reator pistão

#plug-flow

Neste notebook damos continuidade ao precedente através da extensão do modelo para a resolução da conservação de energia empregando a entalpia do fluido como variável independente. O caso tratado será o mesmo estudado anteriormente para que possamos ter uma base de comparação da solução. Realizada a primeira introdução, os notebooks da série se tornam mais concisos e focados cada vez mais em código ao invés de derivações, exceto quando implementando novas físicas.

```julia; @example notebook
using CairoMakie
using PlutoUI
using Printf
using Roots
using SparseArrays
```

Algumas funções de suporte que já foram bem estabelecidas no estudo se encontram em um módulo `PlugFlowReactors.jl` que pode ser importado localmente. Esse módulo será progressivamente alimentado com os blocos de código que vão encontrando maturidade para mais tarde integrar um módulo principal da `WallyToolbox.jl`.

```julia; @example notebook
@info "Importando PlugFlowReactors.jl..."

# Fake a disponibilidade do pacote no caminho de importação.
push!(LOAD_PATH, @__DIR__)

using PlugFlowReactors: heattransfercoef
```

Dado seu uso restrito, não adicionamos `analyticalthermalpfr` ao módulo acima.

```julia; @example notebook
"Solução analítica do modelo de reator pistão."
function analyticalthermalpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)
    return @. Tₛ - (Tₛ - Tₚ) * exp(-z * (ĥ * P) / (ρ * u * cₚ * A))
end
nothing; #hide
```

## Condições compartilhadas


Na próxima célula provemos as mesmas condições do problema tradado no notebook precedente. Uma discretização espacial mais grosseira é utilizada aqui e a
função entalpia compatível com o calor específico do fluido é provida.

Para que os resultados sejam comparáveis as soluções precedentes, definimos 

$$
h(T)=c_{p}T+ h_{ref}
$$

O valor de $h_{ref}$ é arbitrário e não afeta a solução.

```julia; @example notebook
# Comprimento do reator [m]
L = 10.0

# Diâmetro do reator [m]
D = 0.01

# Mass específica do fluido [kg/m³]
ρ = 1000.0

# Viscosidade do fluido [Pa.s]
μ = 0.001

# Calor específico do fluido [J/(kg.K)]
cₚ = 4182.0

# Número de Prandtl do fluido
Pr = 6.9

# Velocidade do fluido [m/s]
u = 1.0

# Temperatura de entrada do fluido [K]
Tₚ = 300.0

# Temperatura da parede do reator [K]
Tₛ = 400.0

# Perímetro da seção circular do reator [m]
P = π * D

# Área da seção circula do reator [m²]
A = π * (D / 2)^2

# Coeficiente convectivo de troca de calor [W/(m².K)]
ĥ = heattransfercoef(L, D, u, ρ, μ, cₚ, Pr; verbose = true)

# Coordenadas espaciais da solução [m]
z = LinRange(0, L, 500)

# Entalpia com constante arbitrária [J/kg]
h(T) = cₚ * T + 1000.0

nothing; #hide
```

## Modelo na entalpia


Em diversos casos a forma expressa na temperatura não é conveniente. Esse geralmente é o caso quando se inclui transformações de fase no sistema. Nessas situações a solução não suporta integração direta e devemos recorrer a um método iterativo baseado na entalpia. Isso se dá pela adição de uma etapa suplementar da solução de equações não lineares para se encontrar a temperatura à qual a entalpia corresponde para se poder avaliar as trocas térmicas.

Para se efetuar a integração partimos do modelo derivado anteriormente numa etapa antes da simplificação final para solução na temperatura e agrupamos os parâmetros livres em $$a$$

$$
\frac{dh}{dz}=\frac{\hat{h}P}{\rho{}u{}A_{c}}(T_{s}-T^{\star})=a(T_{s}-T^{\star})
$$

É interessante observar que toda a discussão precedente acerca de porque não integrar sobre $$T^{\star}$$ perde seu sentido aqui: a temperatura é claramente um parâmetro.

$$
\int_{h_P}^{h_N}dh=a^{\prime}\int_{0}^{\delta}(T_{s}-T^{\star})dz
$$


Seguindo um procedimento de integração similar ao aplicado na formulação usando a temperatura chegamos a equação do gradiente fazendo $a=a^{\prime}\delta$

$$$
h_{E}-h_{P}=aT_{s}-aT^{\star}
$$

Seguindo a mesma lógica discutida na formulação na temperatura, introduzimos a relação de interpolação $T^{\star}=(1/2)(T_{E}+T_{P})$ e aplicando-se esta expressão na forma numérica final, após manipulação chega-se à

$$
-2h_{P}+2h_{E}=2aT_{s}-aT_{E}-aT_{P}
$$ 

Essa expressão permite a solução da entalpia e a atualização do campo de temperaturas se faz através da solução de uma equação não linear do tipo $h(T_{P})-h_{P}=0$ por célula.

Substituindo a temperatura inicial $T_{0}$ e sua entalpia associada $h_{0}$ na forma algébrica do problema encontramos a primeira linha da matriz que explicita as modificações para se implementar a condição inicial do problema

$$
2h_{1}=2aT_{s}-aT_{1}-aT_{0}-2h_{0}
$$

Completamos assim as derivações para se escrever a forma matricial

$$
\begin{bmatrix}
 2      &  0     &  0     & \dots  &  0      &  0      \\
-2      &  2     &  0     & \dots  &  0      &  0      \\
 0      & -2     &  2     & \ddots &  0      &  0      \\
\vdots  & \ddots & \ddots & \ddots & \ddots  & \vdots  \\
 0      &  0     &  0     & -2     &  2      &  0     \\
 0      &  0     &  0     &  0     & -2      &  2 \\
\end{bmatrix}
\begin{bmatrix}
h_{1}    \\
h_{2}    \\
h_{3}    \\
\vdots   \\
h_{N-1}  \\
h_{N}    \\
\end{bmatrix}
=
\begin{bmatrix}
f_{0,1} + 2h(T_{0}) \\
f_{1,2}     \\
f_{2,3}      \\
\vdots                       \\
f_{N-2,N-1}  \\
f_{N-1,N}    \\
\end{bmatrix}
$$

No vetor do lado direito introduzimos uma função de $f$ dada por

$$
f_{i,j} = 2aT_{s} - a(T_{i}+T_{j})
$$


## Solução em volumes finitos


Como as temperaturas usadas no lado direito da equação não são conhecidas inicialmente, o problema tem um carater iterativo intrínsico. Initializamos o lado direito da equação para em seguida resolver o problema na entalpia, que
deve ser invertida (equações não lineares) para se atualizar as temperaturas. Isso se repete até que a solução entre duas iterações consecutivas atinja um *critério de convergência*.

Como a estimativa inicial do campo de temperaturas pode ser extremamente ruim, usamos um método com relaxações consecutivas da solução no caminho da convergência. A ideia de base é evitar atualizações bruscas que podem gerar temperaturas negativas ou simplesmente divergir para o infinito. A cada passo, partindo das temperaturas $T^{(m)}$, aonde $m$ é o índice da iteração, resolvemos o sistema não-linear para encontrar $T^{(m+1)^\prime}$. Pelas razões citadas, não é razoável utilizar essa solução diretamente, portanto realizamos a ponderação, dita relaxação, que se segue

$$
T^{(m+1)}=(1-\alpha)T^{(m+1)^\prime}+αT^{(m)}
$$

O fator $\alpha$ representa neste caso a *fração* de contribuição da solução anterior a nova estimativa. Essa é somente a ponta do iceberg em termos de relaxação e ao longo da série veremos em mais detalhes o conceito. Como critério de parada do cálculo, o que chamamos convergência, queremos que a máxima *atualização* $\Delta{}T$ relativa do campo de temperaturas seja menor que um critério $\varepsilon$, ou seja

$$
\max\frac{\vert{}T^{(m+1)}-T^{(m)}\vert}{\vert{}\max{T^{(m)}}\vert}=
\max\biggr\vert{}\frac{\Delta{}T{}}{\max{}T^{(m)}}\biggr\vert<\varepsilon
$$

Para evitar cálculos separados da nova temperatura e então da variação, podemos usar as definições acima para chegar à

$$
\Delta{}T{} = (1-\alpha)(T^{(m+1)^\prime}-T^{(m)})
$$

e então atualizar a solução com $T^{(m+1)}=T^{(m)}+\Delta{}T{}$.

A solução integrando esses passos foi implementada em `solventhalpypfr`. Para simplificar a leitura do código o problema é implementado em diversos blocos de funções para montagem da função gerindo a solução do modelo.

```julia; @example notebook
"Calcula matriz advectiva do lado esquedo da equação."
function fvmlhs(N)
    return 2spdiagm(-1 => -ones(N - 1), 0 => ones(N))
end
nothing; #hide
```

```julia; @example notebook
"Calcula parte constante do vetor do lado direito da equação."
function fvmrhs(N; bₐ, b₁)
    b = bₐ * ones(N)
    b[1] += b₁
    return b
end
nothing; #hide
```

```julia; @example notebook
"Relaxa solução em termos da entalpia."
function relaxenthalpy(h̄, hₘ, Tₘ, α)
    Δ = (1 - α) * (h̄ - hₘ[2:end])
    m = maximum(hₘ)

    hₘ[2:end] += Δ

    # Solução das temperaturas compatíveis com hm.
    Tₘ[2:end] = map((Tₖ, hₖ) -> find_zero(t -> h(t) - hₖ, Tₖ), Tₘ[2:end], hₘ[2:end])

    return Tₘ, Δ, m
end
nothing; #hide
```

```julia; @example notebook
"Relaxa solução em termos da temperatura."
function relaxtemperature(h̄, hₘ, Tₘ, α)
    # Solução das temperaturas compatíveis com h̄.
    Uₘ = map((Tₖ, hₖ) -> find_zero(t -> h(t) - hₖ, Tₖ), Tₘ[2:end], h̄)

    Δ = (1 - α) * (Uₘ - Tₘ[2:end])
    m = maximum(Tₘ)

    Tₘ[2:end] += Δ

    return Tₘ, Δ, m
end
nothing; #hide
```

```julia; @example notebook
"Realiza uma iteração usando a relaxação especificada."
function steprelax(h̄, hₘ, Tₘ, α, how)
    return (how == :h) ? relaxenthalpy(h̄, hₘ, Tₘ, α) : relaxtemperature(h̄, hₘ, Tₘ, α)
end
nothing; #hide
```

```julia; @example notebook
"Integra o modelo diferencial de reator pistão"
function solvefvmpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, h, z, kw...)
    N = length(z) - 1

    # Parâmetros para o solver.
    M = get(kw, :M, 100)
    α = get(kw, :α, 0.4)
    ε = get(kw, :ε, 1.0e-12)
    relax = get(kw, :relax, :h)
    verbose = get(kw, :verbose, true)

    # Vamos tratar somente o caso equi-espaçado aqui!
    δ = z[2] - z[1]

    a = (ĥ * P * δ) / (ρ * u * A)

    Tₘ = Tₚ * ones(N + 1)
    hₘ = h.(Tₘ)

    K = fvmlhs(N)
    b = fvmrhs(N; bₐ = 2a * Tₛ, b₁ = 2h(Tₚ))

    # Aloca e inicia em negativo o vetor de residuos. Isso
    # é interessante para o gráfico aonde podemos eliminar
    # os elementos negativos que não tem sentido físico.
    residual = -ones(M)

    verbose && @info "Usando relaxação do tipo $(relax)"

    @time for niter = 1:M
        # Calcula o vetor `b` do lado direito e resolve o sistema.
        h̄ = K \ (b - a * (Tₘ[1:end-1] + Tₘ[2:end]))

        # Relaxa solução para gerir não linearidades.
        Tₘ, Δ, m = steprelax(h̄, hₘ, Tₘ, α, relax)

        # Verifica status da convergência.
        residual[niter] = maximum(abs.(Δ / m))

        if (residual[niter] <= ε)
            verbose && @info("Convergiu após $(niter) iterações")
            break
        end
    end

    return Tₘ, residual
end
nothing; #hide
```

Usamos agora essa função para uma última simulação do problema. Verificamos abaixo que a solução levou um certo número de iterações para convergir. Para concluir vamos averiguar a qualidade da convergência ao longo das iterações na parte inferior do gráfico.

Introduzimos também a possibilidade de se utilizar a relaxação diretamente na entalpia, resolvendo o problema não linear apenas para encontrar diretamente a nova estimação do campo de temperaturas. A figura que segue ilustas o
comportamento de convergência. Neste caso específico (e usando a métrica de convergência em questão) a relaxação em entalpia não apresenta vantagens, mas veremos em outras ocasiões que esta é a maneira mais simples de se fazer convergir uma simulação.

```julia; @example notebook
α = 0.4
ε = 1.0e-12

# Uma chamada para pre-compilação...
verbose = false
solvefvmpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, h, z, α, ε, relax = :T, verbose)
solvefvmpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, h, z, α, ε, relax = :h, verbose)

Tₕ, εₕ = solvefvmpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, h, z, α, ε, relax = :h)
Tₜ, εₜ = solvefvmpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, h, z, α, ε, relax = :T)
Tₐ = analyticalthermalpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)

Tend = @sprintf("%.2f", Tₐ[end])
yrng = (300, 400)

nothing; #hide
```

```julia; @example notebook
with_theme() do
    fig = Figure(size = (720, 600))

    ax = Axis(fig[1, 1])
    lines!(ax, z, Tₐ, color = :red, linewidth = 5, label = "Analítica")
    lines!(ax, z, Tₕ, color = :blue, linewidth = 2, label = "FVM (H)")
    lines!(ax, z, Tₜ, color = :cyan, linewidth = 2, label = "FVM (T)")
    xlims!(ax, (0, L))
    ax.title = "Temperatura final = $(Tend) K"
    ax.xlabel = "Posição [m]"
    ax.ylabel = "Temperatura [K]"
    ax.xticks = range(0.0, L, 6)
    ax.yticks = range(yrng..., 6)
    ylims!(ax, yrng)
    axislegend(position = :rb)

    ax = Axis(fig[2, 1], height = 120)
    lines!(ax, log10.(εₕ[εₕ.>0]), color = :blue, label = "FVM (H)")
    lines!(ax, log10.(εₜ[εₜ.>0]), color = :cyan, label = "FVM (T)")
    ax.xlabel = "Iteração"
    ax.ylabel = "log10(ε)"
    ax.xticks = vcat(1, collect(5:5:30))
    ax.yticks = -12:3:0
    xlims!(ax, 1, 30)
    axislegend(position = :rt)

    fig
end
```

Isso é tudo para esta sessão de estudo! Até a próxima!
