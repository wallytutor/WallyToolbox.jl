# Reator pistão


#plug-flow 

Neste tópico abordamos modelos de reatores pistão em níveis progressivos de complexidade. Os modelos de reator estudados incluem em alguns casos aspectos voltados aos aspectos térmicos e em outros elementos de cinética química. O objetivo final é progressivamente introduzir complexidate em termos da física considerada, mas também em termos das estratégias numéricas empregadas na sua implementação

## Indice de tópicos

### Disponíveis atualmente

- Introdução: solução térmica de um reator incompressível formulado em termos da temperatura. O objetivo é de realizar a introdução ao modelo de reator pistão sem entrar em detalhes involvendo não-linearidades como a dependência da densidade em termos da temperatura ou composição. Ademais, essa forma permite uma solução analítica. Introduz o uso de ModelingToolkit e do método dos volumes finitos.

- Formulação entálpica do reator pistão: casos práticos de aplicação de reatores normalmente envolvem fluidos com propriedades que dependem da temperatura, especialmente o calor específico. Em geral a sua solução  é tratada de forma mais conveniente com uma formulação em termos da entalpia. Continuamos com o mesmo caso elaborado no estudo introdutório modificando as equações para que a solução seja realizada com a entalpia como variável dependente.

### Em fase de concepção

- Reatores em contra corrente: o precedente para um par de reatores em contra-corrente.
- Trocas em fluidos supercríticos: suporte à fluidos supercríticos (água, dióxido de carbono).

### Planejados

- O precedente generalizado para um sólido e um gás (compressível).
- O precedente com coeficiente HTC dependente da posição.
- O precedente com trocas térmicas com o ambiente externo.
- O precedente com inclusão de perda de carga na fase gás.
- O precedente com um modelo de trocas térmicas com meio poroso.
- O precedente com um modelo de efeitos difusivos axiais no sólido.
- O precedente com inclusão da entalpia de fusão no sólido.
- O precedente com inclusão de cinética química no gás.

---
## Introdução

Este é o primeiro notebook de uma série abordando reatores do tipo *pistão* (*plug-flow*) no qual os efeitos advectivos são preponderantes sobre o comportamento difusivo, seja de calor, massa, ou espécies. O estudo e modelagem desse tipo de reator apresentar diversos interesses para a pesquisa fundamental e na indústria. Muitos reatores tubulares de síntese laboratorial de materiais apresentam aproximadamente um comportamento como tal e processos nas mais diversas indústrias podem ser aproximados por um ou uma rede de reatores pistão e reatores agitados interconectados.

Começaremos por um caso simples considerando um fluido incompressível e ao longo da série aumentaremos progressivamente a complexidade dos modelos. Os notebooks nessa série vão utilizar uma estratégia focada nos resultados, o que indica que o código será na maior parte do tempo ocultado e o estudante interessado deverá executar o notebook por si mesmo para estudar as implementações.

Nesta *Parte 1* vamos estuda a formulação na temperatura da equação de conservação de energia.

```julia
using WallyToolbox
using DryTransport

using CairoMakie
using DelimitedFiles
using DifferentialEquations: solve
using DocStringExtensions
using Interpolations
using ModelingToolkit
using Polynomials
using Printf
using Roots
using SparseArrays
using SparseArrays: spdiagm
using SteamTables
   
nothing; #hide
```

No que se segue vamos implementar a forma mais simples de um reator pistão. Para este primeiro estudo o foco será dado apenas na solução da equação da energia. As etapas globais implementadas aqui seguem o livro de [Kee *et al.* (2017)](https://www.wiley.com/en-ie/Chemically+Reacting+Flow%3A+Theory%2C+Modeling%2C+and+Simulation%2C+2nd+Edition-p-9781119184874), seção 9.2.

Da forma simplificada como tratado, o problema oferece uma solução analítica análoga à [lei do resfriamento de Newton](https://pt.wikipedia.org/wiki/Lei_do_resfriamento_de_Newton), o que é útil para a verificação do problema. Antes de partir a derivação do modelo, os cálculos do número de Nusselt para avaliação do coeficiente de transferência de calor são providos no que se segue com expressões de Gnielinski e Dittus-Boelter discutidas [aqui](https://en.wikipedia.org/wiki/Nusselt_number).

Abaixo realizamos uma série de testes para verificação dos cálculos do número de Nusselt dadas as múltiplas configurações de parâmetros (complexidade ciclomática) possíveis. As implementatações se encontram no módulo `DryTransport`.

```julia
nu_gn = NusseltGnielinski()
nu_db = NusseltDittusBoelter()

aspect_ratio = 100.0
validate = true

try nusselt(nu_gn, 5.0e+07, 0.7; validate)                     catch end
try nusselt(nu_gn, 5.0e+03, 0.4; validate)                     catch end
try nusselt(nu_gn, 5.0e+07, 0.4; validate)                     catch end
try nusselt(nu_db, 5.0e+03, 0.7; validate, aspect_ratio)       catch end
try nusselt(nu_db, 5.0e+04, 0.5; validate, aspect_ratio)       catch end
try nusselt(nu_db, 5.0e+04, 0.7; validate, aspect_ratio = 1.0) catch end
nothing; #hide
```

Para cobrir toda uma gama de números de Reynolds, a função `htc` avalia  `Nu` com seletor segundo valor de `Re` para o cálculo do número de Nusselt e uma funcionalidade para reportar os resultados, o que pode ser útil na pré-análise do problema.

```julia
let
    L  = 100.0
    D  = 1.0
    u  = 1.0
    ρ  = 1000.0
    μ  = 0.01
    cₚ = 4200.0
    θ  = 298.15
    kw = (verbose = true,)
    
    pr = ConstantPrandtl(0.7)
    re = ReynoldsPipeFlow()
    nu = NusseltGnielinski()
    
    hf = HtcPipeFlow(re, nu, pr)
    htc(hf, θ, u, D, ρ, μ, cₚ; kw...)
    hf
end
```

### Condições compartilhadas

```julia
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

# Cria objeto para avaliação do coeficiente de troca convectiva.
hf = HtcPipeFlow(ReynoldsPipeFlow(), NusseltGnielinski(), ConstantPrandtl(Pr))

# Coeficiente convectivo de troca de calor [W/(m².K)]
ĥ = htc(hf, Tₛ, u, D, ρ, μ, cₚ; verbose = true)

# Coordenadas espaciais da solução [m]
z = LinRange(0, L, 10_000)
nothing; #hide
```
### Solução analítica da EDO

O modelo tratado no que se segue é proposto em detalhes [aqui](../Science/10-Continuum-Mechanics.md).

Sua solução analítica é implementada abaixo em `analyticalthermalpfr`:

```julia
"Solução analítica do modelo de reator pistão."
function analyticalthermalpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)
    return @. Tₛ - (Tₛ - Tₚ) * exp(-z * (ĥ * P) / (ρ * u * cₚ * A))
end
nothing; #hide
```

O bloco abaixo resolve o problema para um conjunto de condições que você pode consultar nos anexos e expandindo o seu código. Observe abaixo da célula um *log* do cálculo dos números adimensionais relevantes ao problema e do coeficiente de transferência de calor convectivo associado. Esses elementos são tratados por funções externas que se encontram em um arquivo de suporte a esta série e são tidos como conhecimentos *a priori* para as discussões.

```julia
with_theme() do
    Tₐ = analyticalthermalpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)
    Tend = @sprintf("%.2f", Tₐ[end])
    yrng = (300, 400)
        
    fig = Figure(size = (720, 500))
    ax = Axis(fig[1, 1])
    lines!(ax, z, Tₐ, color = :red, linewidth = 5, label = "Analítica")
    xlims!(ax, (0, L))
    ax.title = "Temperatura final = $(Tend) K"
    ax.xlabel = "Posição [m]"
    ax.ylabel = "Temperatura [K]"
    ax.xticks = range(0.0, L, 6)
    ax.yticks = range(yrng..., 6)
    ylims!(ax, yrng)
    axislegend(position = :rb)
    fig
end
```

### Integração numérica da EDO

Neste exemplo tivemos *sorte* de dispor de uma solução analítica. Esse problema pode facilmente tornar-se intratável se considerarmos uma dependência arbitrária do calor específico com a temperatura ou se a parede do reator tem uma dependência na coordenada axial. É importante dispor de meios numéricos para o tratamento deste tipo de problema.

No caso de uma equação diferencial ordinária (EDO) como no presente caso, a abordagem mais simples é a de se empregar um integrador numérico. Para tanto é prática comum estabelecer uma função que representa o *lado direito* do problema isolando a(s) derivada(s) no lado esquerdo. Em Julia dispomos do *framework* de `ModelingToolkit` que provê uma forma simbólica de representação de problemas e interfaces com diversos integradores. A estrutura `DifferentialEquationPFR` abaixo implementa o problema diferencial desta forma.

```julia
pfr = let
    @variables z
    D = Differential(z)

    @mtkmodel PFR begin
        @parameters begin
            P
            A
            Tₛ
            ĥ
            u
            ρ
            cₚ
        end

        @variables begin
            T(z)
        end

        @equations begin
            D(T) ~ ĥ * P * (Tₛ - T) / (ρ * u * A * cₚ)
        end
    end

    @mtkbuild pfr = PFR()
end;
```

Uma funcionalidade bastante interessante de `ModelingToolkit` é sua capacidade de representar diretamente em com $\LaTeX$ as equações implementadas. Antes de proceder a solução verificamos na célula abaixo que a equação estabelecida no modelo está de acordo com a formulação que derivamos para o problema diferencial. Verifica-se que a ordem dos parâmetros pode não ser a mesma, mas o modelo é equivalente.

```julia
pfr
```

Para integração do modelo simbólico necessitamos substituir os parâmetros por valores numéricos e fornecer a condição inicial e intervalo de integração ao integrador que vai gerir o problema. A interface `solveodepfr` realiza essas etapas. É importante mencionar aqui que a maioria dos integradores numéricos vai *amostrar* pontos na coordenada de integração segundo a *rigidez numérica* do problema, de maneira que a solução retornada normalmente não está sobre pontos equi-espaçados. Podemos fornecer um parâmetro opcional para recuperar a solução sobre os pontos desejados, o que pode facilitar, por exemplo, comparação com dados experimentais.

```julia
"Integra o modelo diferencial de reator pistão"
function solvemtkpfr(; pfr, P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)
    T₀ = [pfr.T => Tₚ]

    p = [
        pfr.P => P,
        pfr.A => A,
        pfr.Tₛ => Tₛ,
        pfr.ĥ => ĥ,
        pfr.u => u,
        pfr.ρ => ρ,
        pfr.cₚ => cₚ,
    ]

    zspan = (0, z[end])
    prob = ODEProblem(pfr, T₀, zspan, p)

    return solve(prob; saveat = z)
end
nothing; #hide
```

Com isso podemos proceder à integração com ajuda de `solveodepfr` concebida acima e aproveitamos para traçar o resultado em conjunto com a solução analítica.

```julia
with_theme() do
    Tₐ = analyticalthermalpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)
    Tₒ = solvemtkpfr(; pfr, P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)[:T]
    
    Tend = @sprintf("%.2f", Tₐ[end])
    yrng = (300, 400)
    
    fig = Figure(size = (720, 500))
    ax = Axis(fig[1, 1])
    lines!(ax, z, Tₐ, color = :red, linewidth = 5, label = "Analítica")
    lines!(ax, z, Tₒ, color = :black, linewidth = 2, label = "ModelingToolkit")
    xlims!(ax, (0, L))
    ax.title = "Temperatura final = $(Tend) K"
    ax.xlabel = "Posição [m]"
    ax.ylabel = "Temperatura [K]"
    ax.xticks = range(0.0, L, 6)
    ax.yticks = range(yrng..., 6)
    ylims!(ax, yrng)
    axislegend(position = :rb)
    fig
end
```

### Método dos volumes finitos

A construção e solução deste problema é provida em `solvefvmpfr` abaixo.

```julia
"Integra o modelo diferencial de reator pistão"
function solvefvmpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)
    N = length(z) - 1

    # Vamos tratar somente o caso equi-espaçado aqui!
    δ = z[2] - z[1]

    a = (ρ * u * cₚ * A) / (ĥ * P * δ)

    A⁺ = (2a + 1) / (2Tₛ)
    A⁻ = (2a - 1) / (2Tₛ)

    b = ones(N)
    b[1] = 1 + A⁻[1] * Tₚ

    M = spdiagm(-1 => -A⁻ * ones(N - 1), 0 => +A⁺ * ones(N))
    U = similar(z)

    U[1] = Tₚ
    U[2:end] = M \ b

    return U
end
nothing; #hide
```

Abaixo adicionamos a solução do problema sobre malhas grosseiras sobre as soluções desenvolvidas anteriormente. A ideia de se representar sobre malhas grosseiras é simplesmente ilustrar o caráter discreto da solução, que é representada como constante no interior de uma célula. Adicionalmente representamos no gráfico um resultado interpolado de uma simulação CFD 3-D de um reator tubular em condições *supostamente identicas* as representadas aqui, o que mostra o bom acordo de simulações 1-D no limite de validade do modelo.

```julia
with_theme() do
    data = readdlm("data/fluent-reference/postprocess.dat", Float64)
    x, Tᵣ = data[:, 1], data[:, 2]
    
    Tₐ = analyticalthermalpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)
    Tₒ = solvemtkpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z, pfr)[:T]
    Tₑ = solvefvmpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)
    
    Tend = @sprintf("%.2f", Tₐ[end])
    yrng = (300, 400)
    
    fig = Figure(size = (720, 500))
    ax = Axis(fig[1, 1])
    lines!(ax, z, Tₐ, color = :red, linewidth = 5, label = "Analítica")
    lines!(ax, z, Tₒ, color = :black, linewidth = 2, label = "ModelingToolkit")
    lines!(ax, z, Tₑ, color = :blue, linewidth = 2, label = "Finite Volumes")
    lines!(ax, x, Tᵣ, color = :green, linewidth = 2, label = "CFD 3D")
    xlims!(ax, (0, L))
    ax.title = "Temperatura final = $(Tend) K"
    ax.xlabel = "Posição [m]"
    ax.ylabel = "Temperatura [K]"
    ax.xticks = range(0.0, L, 6)
    ax.yticks = range(yrng..., 6)
    ylims!(ax, yrng)
    axislegend(position = :rb)
    fig
end
```

Podemos também réalizar um estudo de sensibilidade a malha:

```julia
with_theme() do
    Tₐ = analyticalthermalpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)

    Tend = @sprintf("%.2f", Tₐ[end])
    yrng = (300, 400)
    
    fig = Figure(size = (720, 500))
    ax = Axis(fig[1, 1])
    lines!(ax, z, Tₐ, color = :red, linewidth = 5, label = "Analítica")

    for (c, N) in [(:blue, 20), (:green, 50)]
        z = LinRange(0.0, L, N)
        Tₑ = solvefvmpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)
        stairs!(ax, z, Tₑ, color = c, label = "N = $(N)", step = :center)
    end

    xlims!(ax, (0, L))
    ax.title = "Temperatura final = $(Tend) K"
    ax.xlabel = "Posição [m]"
    ax.ylabel = "Temperatura [K]"
    ax.xticks = range(0.0, L, 6)
    ax.yticks = range(yrng..., 6)
    ylims!(ax, yrng)
    axislegend(position = :rb)
    fig
end
```

Com isso encerramos essa primeira introdução a modelagem de reatores do tipo pistão. Estamos ainda longe de um modelo generalizado para estudo de casos de produção, mas os principais blocos de construção foram apresentados. Os pontos principais a reter deste estudo são:

- A equação de conservação de massa é o ponto chave para a expansão e   simplificação das demais equações de conservação. Note que isso é uma consequência de qua a massa corresponde à aplicação do [Teorema de Transporte de Reynolds](https://pt.wikipedia.org/wiki/Teorema_de_transporte_de_Reynolds) sobre a *unidade 1*.

- Sempre que a implementação permita, é mais fácil de se tratar o problema como uma EDO e pacotes como ModelingToolkit proveem o ferramental básico para a construção deste tipo de modelos facilmente.

- Uma implementação em volumes finitos será desejável quando um acoplamento com   outros modelos seja envisajada. Neste caso a gestão da solução com uma EDO a parâmetros variáveis pode se tornar computacionalmente proibitiva, seja em   complexidade de código ou tempo de cálculo.

---
## Formulação na entalpia

#plug-flow

Neste notebook damos continuidade ao precedente através da extensão do modelo para a resolução da conservação de energia empregando a entalpia do fluido como variável independente. O caso tratado será o mesmo estudado anteriormente para que possamos ter uma base de comparação da solução. Realizada a primeira introdução, os notebooks da série se tornam mais concisos e focados cada vez mais em código ao invés de derivações, exceto quando implementando novas físicas.


### Condições compartilhadas

Salvo pela discretização espacial mais grosseira e a função entalpia compatível com o calor específico do fluido provida, continuaremos com os parâmetros empregados no estudo precedente. Para que os resultados sejam comparáveis, definimos 

$$
h(T)=c_{p}T+ h_{ref}
$$

O valor de $h_{ref}$ é arbitrário e não afeta a solução.

```julia
# Coordenadas espaciais da solução [m]
z = LinRange(0, L, 500)

# Entalpia com constante arbitrária [J/kg]
h(T) = cₚ * T + 1000.0
nothing; #hide
```

### Modelo na entalpia

A solução integrando esses passos foi implementada em `solventhalpypfr`. Para simplificar a leitura do código o problema é implementado em diversos blocos de funções para montagem da função gerindo a solução do modelo.

```julia
"Calcula matriz advectiva do lado esquedo da equação."
function fvmlhs(N)
    return 2spdiagm(-1 => -ones(N - 1), 0 => ones(N))
end

"Calcula parte constante do vetor do lado direito da equação."
function fvmrhs(N; bₐ, b₁)
    b = bₐ * ones(N)
    b[1] += b₁
    return b
end

"Relaxa solução em termos da entalpia."
function relaxenthalpy(h̄, hₘ, Tₘ, α)
    Δ = (1 - α) * (h̄ - hₘ[2:end])
    m = maximum(hₘ)

    hₘ[2:end] += Δ

    # Solução das temperaturas compatíveis com hm.
    Tₘ[2:end] = map((Tₖ, hₖ) -> find_zero(t -> h(t) - hₖ, Tₖ), Tₘ[2:end], hₘ[2:end])

    return Tₘ, Δ, m
end

"Relaxa solução em termos da temperatura."
function relaxtemperature(h̄, hₘ, Tₘ, α)
    # Solução das temperaturas compatíveis com h̄.
    Uₘ = map((Tₖ, hₖ) -> find_zero(t -> h(t) - hₖ, Tₖ), Tₘ[2:end], h̄)

    Δ = (1 - α) * (Uₘ - Tₘ[2:end])
    m = maximum(Tₘ)

    Tₘ[2:end] += Δ

    return Tₘ, Δ, m
end

"Realiza uma iteração usando a relaxação especificada."
function steprelax(h̄, hₘ, Tₘ, α, how)
    return (how == :h) ? relaxenthalpy(h̄, hₘ, Tₘ, α) : relaxtemperature(h̄, hₘ, Tₘ, α)
end
nothing; #hide
```

```julia
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

    loop() =  begin
        for niter = 1:M
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
    end

    
    get(kw, :timeit, false) ? (@time loop()) : loop()

    return Tₘ, residual
end
nothing; #hide
```

Usamos agora essa função para uma última simulação do problema. Verificamos abaixo que a solução levou um certo número de iterações para convergir. Para concluir vamos averiguar a qualidade da convergência ao longo das iterações na parte inferior do gráfico.

Introduzimos também a possibilidade de se utilizar a relaxação diretamente na entalpia, resolvendo o problema não linear apenas para encontrar diretamente a nova estimação do campo de temperaturas. A figura que segue ilustas o
comportamento de convergência. Neste caso específico (e usando a métrica de convergência em questão) a relaxação em entalpia não apresenta vantagens, mas veremos em outras ocasiões que esta é a maneira mais simples de se fazer convergir uma simulação.

```julia
with_theme() do
    α = 0.4
    ε = 1.0e-12

    # Referência
    Tₐ = analyticalthermalpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)

    # Uma chamada para pre-compilação...
    verbose = false
    solvefvmpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, h, z, α, ε, relax = :T, verbose)
    solvefvmpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, h, z, α, ε, relax = :h, verbose)
    
    # Chamadas para avaliação de performance...
    timeit = true
    Tₕ, εₕ = solvefvmpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, h, z, α, ε, relax = :h, timeit)
    Tₜ, εₜ = solvefvmpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, h, z, α, ε, relax = :T, timeit)
    
    Tend = @sprintf("%.2f", Tₐ[end])
    yrng = (300, 400)
    
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

---
## Reatores em contra corrente

As ideias gerais para a simulação de um reator formulado na entalpia tendo sido introduzidas na *Parte 2*, vamos agora aplicar o mesmo algoritmo de solução para um problema menos trivial: integração de reatores em contra-corrente com trocas térmicas. Esse é o caso, por exemplo, em uma serpentina dupla em contato mecânico. Esse sistema pode ser aproximado por um par de reatores pistão em contra-corrente se tomada propriamente em conta a resistência térmica dos dutos.

Outro caso clássico que pode ser as vezes tratado desta forma é o modelo de forno rotativo para produção de cimento, como discutido por [Hanein *et al.* (2017)](https://doi.org/10.1080/17436753.2017.1303261). Outro exemplo é fornecido por [Bulfin (2019)](https://doi.org/10.1039/C8CP07077F) para a síntese de ceria. [Kerkhof (2007)](https://doi.org/10.1016/j.ces.2006.12.047) apresenta uma abordagem mais geral introduzindo troca de massa entre partículas.

Ainda precisamos tratar de tópicos mais básicos antes de implementar modelos similares ao longo dessa série, mas espero que a literatura citada sirva como motivação para o estudo.

Neste notebook trataremos dois casos:

1. Um par de fluidos que diferem unicamente por seu calor específicos.
1. Um fluido condensado e um gás com propriedades dependentes da temperatura.


### Concepção do programa

Não há nada de diferente em termos do modelo de cada reator em relação ao tópico anterior abordando um reator pistão em termos da entalpia. O objetivo principal do programa a conceber neste notebook é usar os conhecimentos adquiridos na etapa anterior para implementar uma solução para um par de reatores que trocam energia entre si. Para simplificar a implementação vamos considerar que as paredes externas dos reatores são adiabáticas e que estes trocam calor somente entre eles mesmos. Algumas ideias chave são necessárias para uma implementação efetiva:

1. É importante lembrar que as coordenadas dos reatores são invertidas entre elas. Se o reator $r₁$ está orientado no sentido do eixo $z$, então para um par de reatores de comprimento $L$ as coordenadas das células homólogas em $r₂$ são $L-z$.

1. Falando em células homólogas, embora seja possível implementar reatores conectados por uma parede com discretizações distintas, é muito mais fácil de se conceber um programa com reatores que usam a mesma malha espacial. Ademais, isso evita possíveis erros numéricos advindos da escolha de um método de interpolação.

1. Embora uma solução acoplada seja possível, normalmente isso torna o programa mais complexo para se extender a um número arbitrário de reatores e pode conduzir a matrizes com [condição](https://en.wikipedia.org/wiki/Condition_number) pobre. Uma ideia para resolver o problema é realizar uma iteração em cada reator com o outro mantido constante (como no problema precedente) mas desta vez considerando que a *condição limite* da troca térmica possui uma dependência espacial.

Os blocos que se seguem implementam as estruturas necessárias com elementos reutilizáveis de maneira que ambos os reatores possam ser conectados facilmente.

Como desejamos simular simultâneamente dois reatores, é interessante encapsular a construção dos elementos descrevendo um reator em uma estrutura. Desta forma evitamos código duplicado.

```julia
"Tipo para qualquer reator pistão."
abstract type AbstractPlugFlowReactor end
```

````julia
"""
Descrição de um reator pistão formulado na entalpia.

```math
\\frac{dh}{dz}=a(T_{s}(z)-T^{\\star})
\\qquad\\text{aonde}\\qquad
a=\\frac{\\hat{h}P}{\\rho{}u{}A_{c}}
```

O modelo é representado em volumes finitos como ``Kh=b`` tal
como discutido no notebook anterior. Os parâmetros da estrutura
listado abaixo visam manter uma representação tão próxima quanto
possível da expressão matemática do modelo.
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
````

As próximas células implementam um mapa entre as condições *vistas* por ambos os reatores.

```julia
"Representa um par de reatores em contrafluxo."
struct CounterFlowPFRModel
    this::AbstractPlugFlowReactor
    that::AbstractPlugFlowReactor
end

"Acesso ao perfil de temperatura do primeiro reator em um par."
thistemperature(cf::CounterFlowPFRModel) = cf.this.x

"Acesso ao perfil de temperatura do segundo reator em um par."
thattemperature(cf::CounterFlowPFRModel) = cf.that.x |> reverse

nothing; #hide
```

No que se segue não se fará hipótese de que ambos os escoamentos se dão com o mesmo fluido ou que no caso de mesmo fluido as velocidades são comparáveis. Neste caso mais geral, o número de Nusselt de cada lado da interface difere e portanto o coeficiente de troca térmica convectiva. É portanto necessário estabelecer-se uma condição de fluxo constante na interface das malhas para assegurar a conservação global da energia no sistema... **TODO (escrever, já programado)**

```julia
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

"Conservação de entalpia entre dois reatores em contra-corrente."
function enthalpyresidual(cf::CounterFlowPFRModel)
    enthalpyrate(r) = r.ṁ * (r.h(r.x[end]) - r.h(r.x[1]))

    Δha = enthalpyrate(cf.this)
    Δhb = enthalpyrate(cf.that)
	
    return abs(Δhb + Δha) / abs(Δha)
end

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
nothing; #hide
```

Finalmente provemos a lógica dos laços interno e externo para a solução do problema não linear.

```julia
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
nothing; #hide
```

```julia
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
nothing; #hide
```

```julia
"Ilustração padronizada para a simulação exemplo."
function plotpfrpair(cf::CounterFlowPFRModel; ylims, loc, func = lines!)
    z1 = cf.this.z
    T1 = thistemperature(cf)
    T2 = thattemperature(cf)

    fig = Figure(size = (720, 500))
    ax = Axis(fig[1, 1])
	
    func(ax, z1, T1, label = "r₁ →", color = :blue)#, step = :center)
    func(ax, z1, T2, label = "r₂ ←", color = :red)#,  step = :center)

    ax.xticks = range(0.0, z1[end], 6)
    ax.yticks = range(ylims..., 6)
    ax.xlabel = "Posição [m]"
    ax.ylabel = "Temperatura [K]"
    xlims!(ax, (0, z1[end]))
    ylims!(ax, ylims)
    axislegend(position = loc)

    return fig
end
nothing; #hide
```

### Estudo de caso I

O par escolhido para exemplificar o comportamento de contra-corrente dos reatores
pistão tem por característica de que cada reator ocupa a metade de um cilindro de diâmetro $D$ m de forma que o perímetro de troca é igual o diâmetro e a área transversal a metade daquela do cilindro.

A temperatura inicial do fluido no reator (1) que escoa da esquerda para a direita é de $(T₁)$ K e naquele em contra-corrente (2) é de $(T₂)$ K.

O fluido do reator (2) tem um calor específico que é o triplo daquele do reator (1).

```julia
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

# Cria objeto para avaliação do coeficiente de troca convectiva.
hf = HtcPipeFlow(ReynoldsPipeFlow(), NusseltGnielinski(), ConstantPrandtl(Pr))

# Coeficiente convectivo de troca de calor [W/(m².K)]
ĥ₁ = htc(hf, T₁, u, D, ρ, μ, cₚ; verbose = true)
ĥ₂ = htc(hf, T₂, u, D, ρ, μ, cₚ; verbose = true)

# Entalpia com constante arbitrária [J/kg]
h₁(T) = cₚ₁ * T + 1000.0
h₂(T) = cₚ₂ * T + 1000.0
nothing; #hide
```

```julia
let
	common = (N = N, L = L, P = P, A = A, ρ = ρ)
	param₁ = (T = T₁, ĥ = ĥ₁, u = u₁, h = h₁)
	param₂ = (T = T₂, ĥ = ĥ₂, u = u₂, h = h₂)
	
	r₁ = ConstDensityEnthalpyPFRModel(; common..., param₁...)
	r₂ = ConstDensityEnthalpyPFRModel(; common..., param₂...)
	cf = CounterFlowPFRModel(r₁, r₂)

	outerloop(cf)

	plotpfrpair(cf; ylims = (300, 400), loc = :rb)
end
```

### Estudo de caso II (draft)

```julia
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
```

## Trocas em fluidos supercríticos


### O estado supercrítico

A condição supercrítica não implica uma transição de fase de primeira ordem propriamente dita. Usando o pacote `SteamTables` implementa propriedades da água em acordo com a *IAPWS Industrial Formulation (1997)* recuperamos a seguinte curva de massa específica. De maneira análoga verificamos a transição progressiva na entalpia. Como buscamos desenvolver um modelo de reator formulado em termos da entalpia, provemos uma função de interpolação para uma pressão dada abaixo. No caso mais geral (com perda de carga) a entalpia deverá ser avaliada para cada célula no domínio do reator.

```julia
with_theme() do
    P = 0.1 * 270.0
    T = collect(300.0:5:1200.0)
    
    ρ = map((t)->1.0 / SpecificV(P, t), T)
    h = map((t)->SpecificH(P, t), T)
    
    T_interp = collect(400.0:25.0:1200.0)
    h_interp = linear_interpolation(T, h)
    
	fig = Figure(size = (720, 600))
    
	ax1 = Axis(fig[1, 1])
	lines!(ax1, T, ρ; color = :black)
	ax1.xlabel = "Temperatura [K]"
	ax1.ylabel = "Mass específica [kg/m³]"
	ax1.xticks = 300:100:1200
	ax1.yticks = 000:200:1000
	xlims!(ax1, (400, 1000))
	ylims!(ax1, (000, 1000))

    ax2 = Axis(fig[2, 1])
    scatter!(ax2, T_interp, h_interp(T_interp); color = :red, alpha = 0.7)
    lines!(ax2, T, h; color = :black)
    ax2.xlabel = "Temperatura [K]"
    ax2.ylabel = "Entalpia específica [kJ/kg]"
    ax2.xticks = 400:100:1000
    ax2.yticks = 000:500:4000
    xlims!(ax2, (400, 1000))
    ylims!(ax2, (500, 4000))
    
    fig
end
```

```julia
# "Integra reator pistão circular no espaço das entalpias."
# function solveenthalpypfr(; mesh::AbstractDomainFVM, P::T, A::T, Tₛ::T, Tₚ::T,
#                             ĥ::T, u::T, ρ::T, h::Function, M::Int64 = 100,
#                             α::Float64 = 0.4, ε::Float64 = 1.0e-10,
#                             alg::Any = Order16(), vars...) where T
#     N = length(mesh.z) - 1

#     Tm = Tₚ * ones(N + 1)
#     hm = h.(Tm)

#     a = (ĥ * P * mesh.δ) / (ρ * u * A)
#     K = 2spdiagm(-1 => -ones(N-1), 0 => ones(N))

#     b = (2a * Tₛ) * ones(N)
#     b[1] += 2h(Tₚ)

#     residual = -ones(M)

#     @time for niter in 1:M
#         Δ = (1-α) * (K\(b - a * (Tm[1:end-1] + Tm[2:end])) - hm[2:end])
#         hm[2:end] += Δ

#         Tm[2:end] = map(
#             (Tₖ, hₖ) -> find_zero(t -> h(t) - hₖ, Tₖ, alg, atol=0.1),
#             Tm[2:end], hm[2:end]
#         )

#         residual[niter] = maximum(abs.(Δ))

#         if (residual[niter] <= ε)
#             @info("Convergiu após $(niter) iterações")
#             break
#         end
#     end

#     return Tm, residual
# end

# let
#     L = 3.0
#     mesh = ImmersedConditionsFVM(; L = L, N = 3000)

#     D = 0.0254 / 2
#     P = π * D
#     A = π * D^2 / 4

#     Tₛ = 873.15
#     ṁ = 60.0 / 3600.0

#     Pₚ = 27.0
#     Tₚ = 300.0
#     ρₚ = 1.0 / SpecificV(Pₚ, Tₚ)
#     uₚ = ṁ / (ρₚ * A)

#     h_interp = let
#         T = collect(300.0:5.0:2000.0)
#         h = map((t)->SpecificH(Pₚ, t), T)
#         linear_interpolation(T, h)
#     end

#     z = mesh.z
#     ĥ = 4000.0

#     # TODO search literature for supercritical!
#     # ĥ = computehtc(; reactor..., fluid..., u = operations.u)

#     h(t) = 1000h_interp(t)

#     pars = (
#         mesh = mesh,
#         P = P,
#         A = A,
#         Tₛ = Tₛ,
#         Tₚ = Tₚ,
#         ĥ = ĥ,
#         u = uₚ,
#         ρ = ρₚ,
#         h = h,
#         M = 1000,
#         α = 0.85,
#         ε = 1.0e-06,
#         alg = Order16()
#     )

#     T, residuals = solveenthalpypfr(; pars...)

#     fig1 = let
#         yrng = (300.0, 900.0)

#         Tend = @sprintf("%.2f", T[end])
#         fig = Figure(resolution = (720, 500))
#         ax = Axis(fig[1, 1])
#         stairs!(ax, z, T,
#                 color = :red, linewidth = 2,
#                 label = "Numérica", step = :center)
#         xlims!(ax, (0, L))
#         ax.title = "Temperatura final = $(Tend) K"
#         ax.xlabel = "Posição [m]"
#         ax.ylabel = "Temperatura [K]"
#         ax.xticks = range(0.0, L, 5)
#         ax.yticks = range(yrng..., 7)
#         ylims!(ax, yrng)
#         axislegend(position = :rb)
#         fig
#     end
# end
```
