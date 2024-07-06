### A Pluto.jl notebook ###
# v0.19.43

using Markdown
using InteractiveUtils

# ╔═╡ fe2c3680-5b91-11ee-282c-c74d3b01ef9b
begin
	@info "Importando ferramentas..."
    import Pkg
    Pkg.activate(Base.current_project())
    
	using CairoMakie
	using DocStringExtensions
	using PlutoUI
	using Polynomials
	using Printf
	using Roots
	using SparseArrays

	# Fake a disponibilidade do pacote no caminho de importação.
	push!(LOAD_PATH, @__DIR__)
	
	using PlugFlowReactors: heattransfercoef
end;

# ╔═╡ f33f5453-dd05-4a4e-ae12-695320fcd70d
md"""
# Reatores em contra corrente

As ideias gerais para a simulação de um reator formulado na entalpia tendo sido introduzidas na *Parte 2*, vamos agora aplicar o mesmo algoritmo de solução para um problema menos trivial: integração de reatores em contra-corrente com trocas térmicas. Esse é o caso, por exemplo, em uma serpentina dupla em contato mecânico. Esse sistema pode ser aproximado por um par de reatores pistão em contra-corrente se tomada propriamente em conta a resistência térmica dos dutos.

Outro caso clássico que pode ser as vezes tratado desta forma é o modelo de forno rotativo para produção de cimento, como discutido por [Hanein *et al.* (2017)](https://doi.org/10.1080/17436753.2017.1303261). Outro exemplo é fornecido por [Bulfin (2019)](https://doi.org/10.1039/C8CP07077F) para a síntese de ceria. [Kerkhof (2007)](https://doi.org/10.1016/j.ces.2006.12.047) apresenta uma abordagem mais geral introduzindo troca de massa entre partículas.

Ainda precisamos tratar de tópicos mais básicos antes de implementar modelos similares ao longo dessa série, mas espero que a literatura citada sirva como motivação para o estudo.

Neste notebook trataremos dois casos:

1. Um par de fluidos que diferem unicamente por seu calor específicos.
1. Um fluido condensado e um gás com propriedades dependentes da temperatura.

$(TableOfContents())
"""

# ╔═╡ 8b528478-c29f-45ad-97bc-ec38d4370504
md"""
## Concepção do programa

Não há nada de diferente em termos do modelo de cada reator em relação ao tópico anterior abordando um reator pistão em termos da entalpia. O objetivo principal do programa a conceber neste notebook é usar os conhecimentos adquiridos na etapa anterior para implementar uma solução para um par de reatores que trocam energia entre si. Para simplificar a implementação vamos considerar que as paredes externas dos reatores são adiabáticas e que estes trocam calor somente entre eles mesmos. Algumas ideias chave são necessárias para uma implementação efetiva:

1. É importante lembrar que as coordenadas dos reatores são invertidas entre elas. Se o reator ``r₁`` está orientado no sentido do eixo ``z``, então para um par de reatores de comprimento ``L`` as coordenadas das células homólogas em ``r₂`` são ``L-z``.

1. Falando em células homólogas, embora seja possível implementar reatores conectados por uma parede com discretizações distintas, é muito mais fácil de se conceber um programa com reatores que usam a mesma malha espacial. Ademais, isso evita possíveis erros numéricos advindos da escolha de um método de interpolação.

1. Embora uma solução acoplada seja possível, normalmente isso torna o programa mais complexo para se extender a um número arbitrário de reatores e pode conduzir a matrizes com [condição](https://en.wikipedia.org/wiki/Condition_number) pobre. Uma ideia para resolver o problema é realizar uma iteração em cada reator com o outro mantido constante (como no problema precedente) mas desta vez considerando que a *condição limite* da troca térmica possui uma dependência espacial.
"""

# ╔═╡ 920af022-29ee-4274-948b-45c766ce5818
md"""
Os blocos que se seguem implementam as estruturas necessárias com elementos reutilizáveis de maneira que ambos os reatores possam ser conectados facilmente.

Pensando na implementação do módulo `PlugFlowReactors.jl` vamos prover um tipo abstrato a partir do qual definiremos o presente e futuros modelos de reator pistão.
"""

# ╔═╡ 559a88ce-eb43-48c1-aa83-826cabb9df53
"Tipo para qualquer reator pistão."
abstract type AbstractPlugFlowReactor end

# ╔═╡ 985cb672-ac32-4ce5-a78b-c8be3f516cab
md"""
### Modelo de reator pistão

Como desejamos simular simultâneamente dois reatores, é interessante encapsular a construção dos elementos descrevendo um reator em uma estrutura. Desta forma evitamos código duplicado.
"""

# ╔═╡ 87cb2263-959c-4e40-a97e-b0a18aa7f9bf
"""
Descrição de um reator pistão formulado na entalpia.

```math
\\frac{dh}{dz}=a(T_{s}(z)-T^{\\star})
\\qquad\\text{aonde}\\qquad
a=\\frac{\\hat{h}P}{\\rho{}u{}A_{c}}
```

O modelo é representado em volumes finitos como ``Kh=b`` tal como discutido no notebook anterior. Os parâmetros da estrutura listado abaixo visam manter uma representação tão próxima quanto possível da expressão matemática do modelo.

$(TYPEDFIELDS)
"""
struct ConstDensityEnthalpyPFRModel <: AbstractPlugFlowReactor
    "Tamanho do problema linear."
    N::Int64

	"Matriz do problema."
	K::SparseMatrixCSC{Float64, Int64}

    "Vetor do problema."
    b::Vector{Float64}

    "Solução do problema."
    x::Vector{Float64}

	"Coeficiente do modelo."
	a::Float64
	
	"Coordenadas espaciais das células do reator."
	z::Vector{Float64}

    "Coeficiente de troca térmica convectiva [W/(m².K)]."
    ĥ::Float64

    "Fluxo mássico através do reator [kg/s]."
    ṁ::Float64

    "Entalpia em função da temperatura [J/kg]."
    h::Function
	
	""" Construtor do modelo de reator pistão.

	`N::Int64`
		Número de células no sistema sem a condição inicial.
	`L::Float64`
		Comprimento total do reator [m].
	`P::Float64`
		Perímetro da de troca de calor do reator [m].
	`A::Float64`
		Área da seção transversal do reator [m²].
	`T::Float64`
		Temperatura inicial do fluido [K].
	`ĥ::Float64`
		Coeficiente de troca convectiva [W/(m².K)].
	`u::Float64`
		Velocidade do fluido [m/s].
	`ρ::Float64`
		Densidade do fluido [kg/m³].
	`h::Function`
		Entalpia em função da temperatura [J/kg].
	"""
	function ConstDensityEnthalpyPFRModel(;
			N::Int64,
			L::Float64,
			P::Float64,
			A::Float64,
			T::Float64,
			ĥ::Float64,
			u::Float64,
			ρ::Float64,
			h::Function
		)
		# Aloca memória para o problema linear.
        K = 2spdiagm(0 => ones(N), -1 => -ones(N-1))
        b = ones(N+0)
        x = ones(N+1)

		# Discretização do espaço, N+1 para condição inicial.
		z = LinRange(0, L, N+1)
		δ = z[2] - z[1]

		# Coeficiente do problema.
		ṁ = ρ * u * A
		a = (ĥ * P * δ) / ṁ
		
		# Inicializa solução constante.
		x[1:end] .= T

		return new(N, K, b, x, a, z, ĥ, ṁ, h)
	end
end

# ╔═╡ c06c6abd-b462-4573-a53e-34c328b8e8fe
md"""
### Acoplando reatores
"""

# ╔═╡ 7344ea6c-09d4-4972-9ad8-12cbd1c1b550
"Representa um par de reatores em contrafluxo."
struct CounterFlowPFRModel
    this::AbstractPlugFlowReactor
    that::AbstractPlugFlowReactor
end

# ╔═╡ 61080bd1-399a-488e-9173-38138f69ef9b
"Acesso ao perfil de temperatura do primeiro reator em um par."
thistemperature(cf::CounterFlowPFRModel) = cf.this.x

# ╔═╡ bc893607-8ee3-4e6a-b261-bc2390c4c785
"Acesso ao perfil de temperatura do segundo reator em um par."
thattemperature(cf::CounterFlowPFRModel) = cf.that.x |> reverse

# ╔═╡ 534cbebf-1b30-4fc4-b082-e133e92f1546
md"""
No que se segue não se fará hipótese de que ambos os escoamentos se dão com o mesmo fluido ou que no caso de mesmo fluido as velocidades são comparáveis. Neste caso mais geral, o número de Nusselt de cada lado da interface difere e portanto o coeficiente de troca térmica convectiva. É portanto necessário estabelecer-se uma condição de fluxo constante na interface das malhas para assegurar a conservação global da energia no sistema... **TODO (escrever, já programado)**
"""

# ╔═╡ 86085f76-1b40-4e72-9c48-a42bdb11330a
"Perfil de temperatura na parede entre dois fluidos respeitando fluxo."
function surfacetemperature(cf::CounterFlowPFRModel)
    T1 = thistemperature(cf)
    T2 = thattemperature(cf)

    ĥ1 = cf.this.ĥ
    ĥ2 = cf.that.ĥ

    Tw1 = 0.5 * (T1[1:end-1] + T1[2:end])
    Tw2 = 0.5 * (T2[1:end-1] + T2[2:end])

    return (ĥ1 * Tw1 + ĥ2 * Tw2) / (ĥ1 + ĥ2)
end

# ╔═╡ f461507b-e3df-487d-83d3-5fc5e6223aa9
"Conservação de entalpia entre dois reatores em contra-corrente."
function enthalpyresidual(cf::CounterFlowPFRModel)
    enthalpyrate(r) = r.ṁ * (r.h(r.x[end]) - r.h(r.x[1]))

    Δha = enthalpyrate(cf.this)
    Δhb = enthalpyrate(cf.that)
	
    return abs(Δhb + Δha) / abs(Δha)
end

# ╔═╡ cbb38c68-a3a6-45ca-9e84-682541b6dd0b
"Método de relaxação baseado na entalpia."
function relaxenthalpy!(Tm, hm, h̄, α, f)
    # Calcula erro e atualização antes!
    Δ = (1-α) * (h̄ - hm[2:end])
    ε = maximum(abs.(Δ)) / abs(maximum(hm))

    # Autaliza solução antes de resolver NLP.
    hm[2:end] += Δ

    # Solução das temperaturas compatíveis com hm.
    Tm[2:end] = map(f, Tm[2:end], hm[2:end])

    return ε
end

# ╔═╡ 2930a5c5-23cc-4773-b14c-d5130bb49050
"Método de relaxação baseado na temperatura."
function relaxtemperature!(Tm, hm, h̄, α, f)
    # XXX: manter hm na interface para compabilidade com relaxenthalpy!
    # Solução das temperaturas compatíveis com h̄.
    Um = map(f, Tm[2:end], h̄)

    # Calcula erro e atualização depois!
    Δ = (1-α) * (Um - Tm[2:end])
    ε = maximum(abs.(Δ)) / abs(maximum(Tm))

    # Autaliza solução com resultado do NLP.
    Tm[2:end] += Δ

    return ε
end

# ╔═╡ ff492961-6c26-456c-828e-7369ea4f1904
md"""
### Gestão de resíduos
"""

# ╔═╡ 681c9491-b353-42d4-b660-5af9e499d948
md"""
### Laços de solução
"""

# ╔═╡ 84286cd4-4c7a-4ef7-b45d-0ad39ea208a0
"Laço interno da solução de reatores em contra-corrente."
function innerloop(
        # residual::ResidualsRaw
		;
        cf::CounterFlowPFRModel,
        inneriter::Int64,
        α::Float64,
        ε::Float64,
        method::Symbol
    )::Int64
	
    relax = (method == :h) ? relaxenthalpy! : relaxtemperature!

    S = surfacetemperature(cf)
    f = (Tₖ, hₖ) -> find_zero(t -> cf.this.h(t) - hₖ, Tₖ)

    K = cf.this.K
    b = cf.this.b
    T = cf.this.x
    a = cf.this.a
    h = cf.this.h

    Tm = T
    hm = h.(Tm)

    b[1:end] = 2a * S
    b[1] += 2h(Tm[1])

	εm = 1.0e+300
	
    for niter in 1:inneriter
        h̄ = K \ (b - a * (Tm[1:end-1] + Tm[2:end]))
        εm = relax(Tm, hm, h̄, α, f)
        # feedinnerresidual(residual, εm)

        if (εm <= ε)
            return niter
        end
    end

    @warn "Não convergiu após $(inneriter) passos $(εm)"
    return inneriter
end

# ╔═╡ f82ab335-4b3a-4345-8160-ac8a89072c86
"Laço externo da solução de reatores em contra-corrente."
function outerloop(
        cf::CounterFlowPFRModel;
        inneriter::Int64 = 50,
        outeriter::Int64 = 500,
        Δhmax::Float64 = 1.0e-10,
        α::Float64 = 0.6,
        ε::Float64 = 1.0e-10,
		method::Symbol = :h
    )#::Tuple{ResidualsProcessed, ResidualsProcessed}
    ra = cf
    rb = CounterFlowPFRModel(cf.that, cf.this)

    # resa = ResidualsRaw(inner, outer)
    # resb = ResidualsRaw(inner, outer)

    @time for nouter in 1:outeriter
        # ca = innerloop(resa; cf = ra, shared...)
        # cb = innerloop(resb; cf = rb, shared...)
        ca = innerloop(; cf = ra, inneriter, α, ε, method)
        cb = innerloop(; cf = rb, inneriter, α, ε, method)

        # resa.innersteps[nouter] = ca
        # resb.innersteps[nouter] = cb

        if enthalpyresidual(cf) < Δhmax
            @info("Laço externo convergiu após $(nouter) iterações")
            break
        end
    end

	hres = @sprintf("%.1e", enthalpyresidual(cf))
    @info("Conservação da entalpia = $(hres)")
    # return ResidualsProcessed(resa), ResidualsProcessed(resb)
end

# ╔═╡ 683707b7-c02f-450c-93aa-f4bfb078407f
md"""
### Pós-processamento
"""

# ╔═╡ 2d296ee3-ed4b-422a-9573-d10bbbdce344
"Ilustração padronizada para a simulação exemplo."
function plotpfrpair(cf::CounterFlowPFRModel; ylims, loc, func = lines!)
    z1 = cf.this.z
    T1 = thistemperature(cf)
    T2 = thattemperature(cf)

    fig = Figure(size = (720, 500))
    ax = Axis(fig[1, 1])
	
    func(ax, z1, T1, label = "r₁ →", color = :blue, step = :center)
    func(ax, z1, T2, label = "r₂ ←", color = :red,  step = :center)

    ax.xticks = range(0.0, z1[end], 6)
    ax.yticks = range(ylims..., 6)
    ax.xlabel = "Posição [m]"
    ax.ylabel = "Temperatura [K]"
    xlims!(ax, (0, z1[end]))
    ylims!(ax, ylims)
    axislegend(position = loc)

    return fig
end

# ╔═╡ f4aac0b4-6f24-4aea-9b1a-0a4811851d01
begin
	@info "Condições para o caso I"
	
	# Número de células no sistema.
	N =  100
	
    # Comprimento do reator [m]
    L = 10.0

    # Diâmetro do reator [m]
    D = 0.01

    # Mass específica dos fluidos [kg/m³]
    ρ = 1000.0

    # Viscosidade dos fluidos [Pa.s]
    μ = 0.001

    # Número de Prandtl dos fluidos
    Pr = 6.9
	
    # Calor específico do fluido [J/(kg.K)]
    cₚ₁ = 1000.0
    cₚ₂ = 3cₚ₁

    # Velocidade do fluido [m/s]
    u₁ = 1.0
    u₂ = 2.0

    # Temperatura de entrada do fluido [K]
    T₁ = 300.0
    T₂ = 400.0

    # Perímetro troca térmica de cada reator [m]
	# XXX: neste casa igual o diâmetro, ver descrição.
    P = D

    # Área da seção circula de cada reator [m²]
    A = (1 // 2) * π * (D / 2)^2

	# Diâmetro equivalente a seção para cada reator.
	d = 2√(A/π)
	
    # Coeficiente convectivo de troca de calor [W/(m².K)]
    ĥ₁ = heattransfercoef(L, d, u₁, ρ, μ, cₚ₁, Pr; verbose = true)
    ĥ₂ = heattransfercoef(L, d, u₂, ρ, μ, cₚ₂, Pr; verbose = true)

    # Entalpia com constante arbitrária [J/kg]
    h₁(T) = cₚ₁ * T + 1000.0
    h₂(T) = cₚ₂ * T + 1000.0
end;

# ╔═╡ 7a278913-bf0f-4532-9c9b-f42aded9b6e9
md"""
## Estudo de caso I

O par escolhido para exemplificar o comportamento de contra-corrente dos reatores
pistão tem por característica de que cada reator ocupa a metade de um cilindro de diâmetro `D` = $(D) m de forma que o perímetro de troca é igual o diâmetro e a área transversal a metade daquela do cilindro.

A temperatura inicial do fluido no reator (1) que escoa da esquerda para a direita é de $(T₁) K e naquele em contra-corrente (2) é de $(T₂) K.

O fluido do reator (2) tem um calor específico que é o triplo daquele do reator (1).
"""

# ╔═╡ 5d3619f9-b0f6-4946-b3f2-fce160c52088
let
	1
	common = (N = N, L = L, P = P, A = A, ρ = ρ)
	param₁ = (T = T₁, ĥ = ĥ₁, u = u₁, h = h₁)
	param₂ = (T = T₂, ĥ = ĥ₂, u = u₂, h = h₂)
	
	r₁ = ConstDensityEnthalpyPFRModel(; common..., param₁...)
	r₂ = ConstDensityEnthalpyPFRModel(; common..., param₂...)
	cf = CounterFlowPFRModel(r₁, r₂)

	outerloop(cf)

	plotpfrpair(cf; ylims = (300, 400), loc = :rb)
end

# ╔═╡ f3b7d46f-0fcc-4f68-9822-f83e977b87ee
md"""
## Estudo de caso II
"""

# ╔═╡ 7afff466-5463-431f-b817-083fe6102a8c
#     # Condições operatórias do gás.
#     p₃ = 101325.0
#     h₃ = integrate(fluid3.cₚpoly)
#     M̄₃ = 0.02897530345830224

#     fluid₃ = (
#         ρ = (p₃ * M̄₃) / (GAS_CONSTANT * operations3.Tₚ),
#         μ = fluid3.μpoly(operations3.Tₚ),
#         cₚ = fluid3.cₚpoly(operations3.Tₚ),
#         Pr = fluid3.Pr
#     )

#     # Condições modificadas do fluido condensado.
#     operations₁ = (
#         u = operations3.u * (fluid₃.ρ / fluid1.ρ),
#         Tₚ = operations1.Tₚ
#     )

#     shared = (
#         N = N,
#         L = reactor.L,
#         P = reactor.D,
#         A = 0.5π * (reactor.D/2)^2,
#         ρ = fluid1.ρ
#     )

#     ĥ₁ = computehtc(; reactor..., fluid1..., u = operations₁.u, verbose = false)
#     ĥ₃ = computehtc(; reactor..., fluid₃..., u = operations3.u, verbose = false)

#     r₁ = IncompressibleEnthalpyPFRModel(;
#         shared...,
#         T = operations₁.Tₚ,
#         u = operations₁.u,
#         ĥ = ĥ₁,
#         h = (T) -> 1.0fluid1.cₚ * T + 1000.0
#     )

#     r₃ = IncompressibleEnthalpyPFRModel(;
#         shared...,
#         T = operations3.Tₚ,
#         u = operations3.u,
#         ĥ = ĥ₃,
#         h = (T) -> h₃(T),
#     )

#     r₁, r₂ = createprfpair2(; N = 1000)
#     cf = CounterFlowPFRModel(r₁, r₂)

#     resa, resb = outerloop(cf;
#         inner = 100,
#         outer = 200,
#         relax = 0.6,
#         Δhmax = 1.0e-10,
#         rtol  = 1.0e-10
#     )

#     fig1 = plotpfrpair(cf, ylims = (300, 400))
#     fig2 = plotreactorresiduals(resa, resb)

# ╔═╡ 2b667c73-1c05-48a5-a6e7-b7490ab5916c
# "Gera grafico com resíduos da simulação"
# function plotreactorresiduals(ra, rb)
#     function getreactordata(r)
#         xg = 1:r.counter
#         xs = r.finalsteps
#         yg = log10.(r.residuals)
#         ys = log10.(r.finalresiduals)
#         return xg, xs, yg, ys
#     end

#     function axlimitmax(niter)
#         rounder = 10^floor(log10(niter))
#         return convert(Int64, rounder * ceil(niter/rounder))
#     end

#     niter = max(ra.counter, rb.counter)
#     xga, xsa, yga, ysa = getreactordata(ra)
#     xgb, xsb, ygb, ysb = getreactordata(rb)

#     fig = Figure(resolution = (720, 500))
#     ax = Axis(fig[1, 1], yscale = identity)

#     ax.xlabel = "Iteração global"
#     ax.ylabel = "log10(Resíduo)"
#     ax.title = "Histórico de convergência"

#     ax.yticks = -12:2:0
#     xlims!(ax, (0, axlimitmax(niter)))
#     ylims!(ax, (-12, 0))

#     lines!(ax, xga, yga, color = :blue,  linewidth = 0.9, label = "r₁")
#     lines!(ax, xgb, ygb, color = :red, linewidth = 0.9, label = "r₂")

#     scatter!(ax, xsa, ysa, color = :black, markersize = 6)
#     scatter!(ax, xsb, ysb, color = :black, markersize = 6)

#     axislegend(position = :rt)
#     return fig
# end

# ╔═╡ cdf10672-6e0a-4535-8797-7a519d47ad76
# "Dados usados nos notebooks da série."
# const notedata = (
#     c03 = (
#         fluid3 = (
#             # Viscosidade do fluido [Pa.s]
#             μpoly = Polynomial([
#                 1.7e-05 #TODO copy good here!
#             ], :T),
#             # Calor específico do fluido [J/(kg.K)]
#             cₚpoly = Polynomial([
#                     959.8458126240355,
#                     0.3029051601580761,
#                     3.988896105280984e-05,
#                     -6.093647929461819e-08,
#                     1.0991100692950414e-11
#                 ], :T),
#             # Número de Prandtl do fluido
#             Pr = 0.70
#         ),
#         operations3 = (
#             u = 2.5,      # Velocidade do fluido [m/s]
#             Tₚ = 380.0,   # Temperatura de entrada do fluido [K]
#         )
#     ),
# )

# "Calcula a potência de `x` mais próxima de `v`."
# function closestpowerofx(v::Number; x::Number = 10)::Number
#     rounder = x^floor(log(x, v))
#     return convert(Int64, rounder * ceil(v/rounder))
# end

# "Gestor de resíduos durante uma simulação."
# mutable struct ResidualsRaw
#     inner::Int64
#     outer::Int64
#     counter::Int64
#     innersteps::Vector{Int64}
#     residuals::Vector{Float64}
#     function ResidualsRaw(inner::Int64, outer::Int64)
#         innersteps = -ones(Int64, outer)
#         residuals = -ones(Float64, outer * inner)
#         return new(inner, outer, 0, innersteps, residuals)
#     end
# end

# "Resíduos de uma simulação processados."
# struct ResidualsProcessed
#     counter::Int64
#     innersteps::Vector{Int64}
#     residuals::Vector{Float64}
#     finalsteps::Vector{Int64}
#     finalresiduals::Vector{Float64}

#     function ResidualsProcessed(r::ResidualsRaw)
#         innersteps = r.innersteps[r.innersteps .> 0.0]
#         residuals = r.residuals[r.residuals .> 0.0]

#         finalsteps = cumsum(innersteps)
#         finalresiduals = residuals[finalsteps]

#         return new(r.counter, innersteps, residuals,
#                    finalsteps, finalresiduals)
#     end
# end

# "Alimenta resíduos da simulação no laço interno."
# function feedinnerresidual(r::ResidualsRaw, ε::Float64)
#     # TODO: add resizing test here!
#     r.counter += 1
#     r.residuals[r.counter] = ε
# end

# ╔═╡ Cell order:
# ╟─f33f5453-dd05-4a4e-ae12-695320fcd70d
# ╟─fe2c3680-5b91-11ee-282c-c74d3b01ef9b
# ╟─8b528478-c29f-45ad-97bc-ec38d4370504
# ╟─920af022-29ee-4274-948b-45c766ce5818
# ╟─559a88ce-eb43-48c1-aa83-826cabb9df53
# ╟─985cb672-ac32-4ce5-a78b-c8be3f516cab
# ╟─87cb2263-959c-4e40-a97e-b0a18aa7f9bf
# ╟─c06c6abd-b462-4573-a53e-34c328b8e8fe
# ╟─7344ea6c-09d4-4972-9ad8-12cbd1c1b550
# ╟─61080bd1-399a-488e-9173-38138f69ef9b
# ╟─bc893607-8ee3-4e6a-b261-bc2390c4c785
# ╟─534cbebf-1b30-4fc4-b082-e133e92f1546
# ╟─86085f76-1b40-4e72-9c48-a42bdb11330a
# ╟─f461507b-e3df-487d-83d3-5fc5e6223aa9
# ╟─cbb38c68-a3a6-45ca-9e84-682541b6dd0b
# ╟─2930a5c5-23cc-4773-b14c-d5130bb49050
# ╟─ff492961-6c26-456c-828e-7369ea4f1904
# ╟─681c9491-b353-42d4-b660-5af9e499d948
# ╟─84286cd4-4c7a-4ef7-b45d-0ad39ea208a0
# ╟─f82ab335-4b3a-4345-8160-ac8a89072c86
# ╟─683707b7-c02f-450c-93aa-f4bfb078407f
# ╟─2d296ee3-ed4b-422a-9573-d10bbbdce344
# ╟─7a278913-bf0f-4532-9c9b-f42aded9b6e9
# ╟─f4aac0b4-6f24-4aea-9b1a-0a4811851d01
# ╟─5d3619f9-b0f6-4946-b3f2-fce160c52088
# ╟─f3b7d46f-0fcc-4f68-9822-f83e977b87ee
# ╠═7afff466-5463-431f-b817-083fe6102a8c
# ╠═2b667c73-1c05-48a5-a6e7-b7490ab5916c
# ╠═cdf10672-6e0a-4535-8797-7a519d47ad76
