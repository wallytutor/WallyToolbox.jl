# Reator pistão


#plug-flow 

Neste tópico abordamos modelos de reatores de uma ótica que pode ser simultâneamente útil em Engenharia Química e Engenharia Mecânica. Os modelos de reator estudados incluem em alguns casos aspectos voltados a engenharia dos aspectos térmicos e em outros elementos de cinética química. Isso inclui modelos 0-D de reatores perfeitamente agitados, modelos 1-D de reatores pistão, e outros tópicos mais avançados.

O objetivo final da série é progressivamente introduzir complexidate em termos da física considerada, mas também na organização de ferramentas para a concepção e extensão de modelos genéricos de reators para integração dos modelos com maturidade suficiente nos módulos principais.

- Introdução: solução térmica de um reator incompressível formulado em termos da temperatura. O objetivo é de realizar a introdução ao modelo de reator pistão sem entrar em detalhes involvendo não-linearidades como a dependência da densidade em termos da temperatura ou composição. Ademais, essa forma permite uma solução analítica. Introduz o uso de ModelingToolkit e do método dos volumes finitos.

- Formulação entálpica do reator pistão: casos práticos de aplicação de reatores normalmente envolvem fluidos com propriedades que dependem da temperatura, especialmente o calor específico. Em geral a sua solução  é tratada de forma mais conveniente com uma formulação em termos da entalpia. Continuamos com o mesmo caso elaborado no estudo introdutório modificando as equações para que a solução seja realizada com a entalpia como variável dependente.

- Reatores em contra corrente: o precedente para um par de reatores em contra-corrente.
- Trocas em fluidos supercríticos: suporte à fluidos supercríticos (água, dióxido de carbono).
- O precedente generalizado para um sólido e um gás (compressível).
- O precedente com coeficiente HTC dependente da posição.
- O precedente com trocas térmicas com o ambiente externo.
- O precedente com inclusão de perda de carga na fase gás.
- O precedente com um modelo de trocas térmicas com meio poroso.
- O precedente com um modelo de efeitos difusivos axiais no sólido.
- O precedente com inclusão da entalpia de fusão no sólido.
- O precedente com inclusão de cinética química no gás.


# Introdução


Este é o primeiro notebook de uma série abordando reatores do tipo *pistão* (*plug-flow*) no qual os efeitos advectivos são preponderantes sobre o comportamento difusivo, seja de calor, massa, ou espécies. O estudo e modelagem desse tipo de reator apresentar diversos interesses para a pesquisa fundamental e na indústria. Muitos reatores tubulares de síntese laboratorial de materiais apresentam aproximadamente um comportamento como tal e processos nas mais diversas indústrias podem ser aproximados por um ou uma rede de reatores pistão e reatores agitados interconectados.

Começaremos por um caso simples considerando um fluido incompressível e ao longo da série aumentaremos progressivamente a complexidade dos modelos. Os notebooks nessa série vão utilizar uma estratégia focada nos resultados, o que indica que o código será na maior parte do tempo ocultado e o estudante interessado deverá executar o notebook por si mesmo para estudar as implementações.

Nesta *Parte 1* vamos estuda a formulação na temperatura da equação de conservação de energia.

```julia; @example notebook
@info "Importando ferramentas..."

using CairoMakie
using DelimitedFiles
using DifferentialEquations: solve
using ModelingToolkit
using PlutoUI
using Printf
using SparseArrays

nothing; #hide
```

No que se segue vamos implementar a forma mais simples de um reator pistão. Para este primeiro estudo o foco será dado apenas na solução da equação da energia. As etapas globais implementadas aqui seguem o livro de [Kee *et al.* (2017)](https://www.wiley.com/en-ie/Chemically+Reacting+Flow%3A+Theory%2C+Modeling%2C+and+Simulation%2C+2nd+Edition-p-9781119184874), seção 9.2.

## Etapas preliminares

Da forma simplificada como tratado, o problema oferece uma solução analítica análoga à [lei do resfriamento de Newton](https://pt.wikipedia.org/wiki/Lei_do_resfriamento_de_Newton), o que é útil para a verificação do problema. Antes de partir a derivação do modelo, os cálculos do número de Nusselt para avaliação do coeficiente de transferência de calor são providos no que se segue com expressões de Gnielinski e Dittus-Boelter discutidas [aqui](https://en.wikipedia.org/wiki/Nusselt_number).

```julia; @example notebook
"Função auxiliar para avaliação exaustiva de critérios de validação."
function testall(tests)
    messages = []

    for (evaluation, message) in tests
        !evaluation && push!(messages, message)
    end

    if !isempty(messages)
        @error join(messages, "\n")
        throw(ArgumentError("Check previous warnings"))
    end
end

"Equação de Gnielinski para número de Nusselt."
function Nu_gnielinski(Re, Pr)
    testall([
        (3000.0 <= Re <= 5.0e+06, "* Re = $(Re) ∉ [3000, 5×10⁶]"),
        (0.5 <= Pr <= 2000.0, "* Pr = $(Pr) ∉ [0.5, 2000]"),
    ])

    f = (0.79 * log(Re) - 1.64)^(-2)
    g = f / 8

    num = g * (Re - 1000) * Pr
    den = 1.0 + 12.7 * (Pr^(2 / 3) - 1) * g^(1 / 2)

    return num / den
end

"Equação de Dittus-Boelter para número de Nusselt."
function Nu_dittusboelter(Re, Pr, L, D; what = :heating)
    testall([
        (Re >= 10000.0, "* Re = $(Re) < 10000"),
        (0.6 <= Pr <= 160.0, "* Pr = $(Pr) ∉ [0.6, 160]"),
        (L / D > 10.0, "* L/D = $(L/D) < 10.0"),
    ])

    n = (what == :heating) ? 0.4 : 0.3

    return 0.023 * Re^(4 // 5) * Pr^n
end

"Avalia número de Nusselt com correlação escolhida."
function Nu(Re, Pr; method = :gnielinski, kw...)
    # Valor para escoamento interno laminar.
    Nu = 3.66

    # Modifica valor com método se turbulento.
    if Re > 3000.0
        if method == :gnielinski
            Nu = Nu_gnielinski(Re, Pr)
        elseif method == :dittusboelter
            what = get(kw, :what, :heating)
            Nu = Nu_dittusboelter(Re, Pr, kw[:L], kw[:D]; what)
        else
            throw(ArgumentError("Unknown method $(method)"))
        end
    end

    return Nu
end

nothing; #hide
```

Abaixo realizamos uma série de testes para verificação dos cálculos do número de Nusselt dadas as múltiplas configurações de parâmetros (complexidade ciclomática) possívels.

```julia; @example notebook
L = 100.0
D = 1.0

try Nu(5.0e+07, 0.7; method = :gnielinski)              catch end
try Nu(5.0e+03, 0.4; method = :gnielinski)              catch end
try Nu(5.0e+07, 0.4; method = :gnielinski)              catch end
try Nu(5.0e+03, 0.7; method = :dittusboelter, L, D)     catch end
try Nu(5.0e+04, 0.5; method = :dittusboelter, L, D)     catch end
try Nu(5.0e+04, 0.7; method = :dittusboelter, L = D, D) catch end
nothing; #hide
```

Para cobrir toda uma gama de números de Reynolds, a função `heattransfercoef` abaixo usa a função `Nu` com seletor segundo valor de `Re` para o cálculo do número de Nusselt e uma funcionalidade para reportar os resultados, o que pode ser útil na pré-análise do problema.

```julia; @example notebook
"Estima coeficiente de troca convectiva do escoamento."
function heattransfercoef(L, D, u, ρ, μ, cₚ, Pr; kw...)
    Re_val = ρ * u * D / μ
    Nu_val = Nu(Re_val, Pr; kw...)

    k = cₚ * μ / Pr
    h = Nu_val * k / D

    if get(kw, :verbose, false)
        @info("""\
            Reynolds ................... $(Re_val)
            Nusselt .................... $(Nu_val)
            k .......................... $(k) W/(m.K)
            h .......................... $(h) W/(m².K)\
            """)
    end

    return h
end

nothing; #hide
```

```julia; @example notebook
L = 100.0
D = 1.0
u = 1.0
ρ = 1000.0
μ = 0.01
cₚ = 4200.0
Pr = 0.7
kw = (verbose = true,)

heattransfercoef(L, D, u, ρ, μ, cₚ, Pr; kw...)
```

## Condições compartilhadas

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
z = LinRange(0, L, 10_000)

nothing; #hide
```

## Derivação do modelo


A primeira etapa no estabelecimento do modelo concerne as equações de conservação necessárias. No presente caso, com a ausência de reações químicas e trocas de matéria com o ambiente - o reator é um tubo fechado - precisamos estabelecer a conservação de massa e energia apenas. Como dito, o reator em questão conserva a massa transportada, o que é matematicamente expresso pela ausência de variação axial do fluxo de matéria, ou seja

$$
\frac{d(\rho{}u)}{dz}=0
$$

Mesmo que trivial, esse resultado é frequentemente útil na simplificação das outras equações de conservação para um reator pistão, como veremos (com frequência) mais tarde.

Embora não trocando matéria com o ambiente a través das paredes, vamos considerar aqui trocas térmicas. Afinal não parece muito útil um modelo de reator sem trocas de nenhum tipo nem reações. Da primeira lei da Termodinâmica temos que a taxa de variação da energia interna $E$ é igual a soma das taxas de trocas de energia $Q$ e do trabalho realizado $W$.

$$
\frac{dE}{dt}= \frac{dQ}{dt}+ \frac{dW}{dt}
$$

Podemos reescrever essa equação para uma seção transversal do reator de área $A_{c}$ em termos das grandezas específicas e densidade $\rho$ com as integrais

$$
\int_{\Omega}\rho{}e\mathbf{V}\cdotp\mathbf{n}dA_{c}=
\dot{Q}-
\int_{\Omega}p\mathbf{V}\cdotp\mathbf{n}dA_{c}
$$

Com a definição de entalpia $h$ podemos simplificar essa equação e obter

$$
\int_{\Omega}\rho{}h\mathbf{V}\cdotp\mathbf{n}dA_{c}=
\dot{Q}\qquad{}\text{aonde}\qquad{}h = e+\frac{p}{\rho}
$$

Usando o teorema de Gauss transformamos essa integral sobre a superfície num integral de divergência sobre o volume diferencial $dV$, o que é útil na manipulação de equações de conservação

$$
\int_{\Omega}\rho{}h\mathbf{V}\cdotp\mathbf{n}dA_{c}=
\int_{V}\nabla\cdotp(\rho{}h\mathbf{V})dV
$$


Nos resta ainda determinar $\dot{Q}$. O tipo de interação com ambiente, numa escala macroscópica, não pode ser representado por leis físicas fundamentais. Para essa representação necessitamos de uma *lei constitutiva* que modela o fenômeno em questão. Para fluxos térmicos convectivos à partir de uma parede com
temperatura fixa $T_{s}$ a forma análoga a uma condição limite de Robin expressa o $\dot{Q}$ como

$$
\dot{Q}=\hat{h}A_{s}(T_{s}-T)=\hat{h}(Pdz)(T_{s}-T)
$$

O coeficiente de troca térmica convectiva $\hat{h}$ é frequentemente determinado à partir do tipo de escoamento usando fórmulas empíricas sobre o número de Nusselt. A abordagem desse tópico vai além do nosso escopo e assume-se que seu valor seja conhecido. Nessa expressão já transformamos a área superficial do reator $A_{s}=Pdz$ o que nos permite agrupar os resultados em

$$
\int_{V}\nabla\cdotp(\rho{}h\mathbf{V})dV=
\hat{h}(Pdz)(T_{w}-T)
$$

Em uma dimensão $z$ o divergente é simplemente a derivada nessa coordenada.
Usando a relação diverencial $\delta{}V=A_{c}dz$ podemos simplificar a equação
para a forma diferencial como se segue

$$
\frac{d(\rho{}u{}h)}{dz}=
\frac{\hat{h}Pdz}{\delta{}V}(T_{w}-T)
\implies
\frac{d(\rho{}u{}h)}{dz}=
\frac{\hat{h}P}{A_{c}}(T_{w}-T)
$$

A expressão acima já consitui um modelo para o reator pistão, mas sua forma não
é facilmente tratável analiticamente. Empregando a propriedade multiplicativa da
diferenciaÇão podemos expandir o lado esquedo da equação como

$$
\rho{}u{}\frac{dh}{dz}+h\frac{d(\rho{}u)}{dz}=
\frac{\hat{h}P}{A_{c}}(T_{w}-T)
$$

O segundo termo acima é nulo em razão da conservação da matéria, como discutimos
anteriormente. Da definição diferencial de entalpia $dh=c_{p}dT$ chegamos a
formulação do modelo na temperatura como dado no título dessa seção.

$$
\rho{}u{}c_{p}A_{c}\frac{dT}{dz}=
\hat{h}P(T_{w}-T)
$$

Vamos agora empregar esse modelo para o cálculo da distribuição axial de
temperatura ao longo do reator. No que se segue assume-se um reator tubular de
seção circular de raio $R$ e todos os parâmetros do modelo são constantes.


## Métodos de solução


### Solução analítica da EDO


O problema tratado aqui permite uma solução analítica simples que desenvolvemos de maneira um pouco abrupta no que se segue. Separando os termos em $T$ (variável dependente) e $z$ (variável independente) e integrando sobre os limites adequados obtemos

$$
\int_{T_{0}}^{T}\frac{dT}{T_{w}-T}=
\frac{\hat{h}P}{\rho{}u{}c_{p}A_{c}}\int_{0}^{z}dz=
\mathcal{C}_{0}z
$$

Na expressão acima $\mathcal{C}_{0}$ não é uma constante de integração mas apenas regrupa os parâmetros do modelo. O termo em $T$ pode ser integrado por uma substituição trivial

$$
u=T_{w}-T \implies -\int\frac{du}{u}=\log(u)\biggr\vert_{u_0}^{u}+\mathcal{C}_{1}
$$

Realizando a integração definida e resolvendo para $T$ chegamos a

$$
T=T_{w}-(T_{w}-T_{0})\exp\left(-\mathcal{C}_{0}z+\mathcal{C}_{1}\right)
$$

É trivial verificar com $T(z=0)=T_{0}$ que $\mathcal{C}_{1}=0$ o que conduz à solução analítica que é implementada no que se segue em `analyticalthermalpfr`.

$$
T=T_{w}-(T_{w}-T_{0})\exp\left(-\frac{\hat{h}P}{\rho{}u{}c_{p}A_{c}}z\right)
$$

```julia; @example notebook
"Solução analítica do modelo de reator pistão."
function analyticalthermalpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)
    return @. Tₛ - (Tₛ - Tₚ) * exp(-z * (ĥ * P) / (ρ * u * cₚ * A))
end
nothing; #hide
```

O bloco abaixo resolve o problema para um conjunto de condições que você pode consultar nos anexos e expandindo o seu código. Observe abaixo da célula um *log* do cálculo dos números adimensionais relevantes ao problema e do coeficiente de transferência de calor convectivo associado. Esses elementos são tratados por funções externas que se encontram em um arquivo de suporte a esta série e são tidos como conhecimentos *a priori* para as discussões.

```julia; @example notebook
Tₐ = analyticalthermalpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)
Tend = @sprintf("%.2f", Tₐ[end])
yrng = (300, 400)

with_theme() do
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

```julia; @example notebook
pfr = let
    @info "Criação do modelo diferencial"

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

```julia; @example notebook
pfr
```

Para integração do modelo simbólico necessitamos substituir os parâmetros por valores numéricos e fornecer a condição inicial e intervalo de integração ao integrador que vai gerir o problema. A interface `solveodepfr` realiza essas etapas. É importante mencionar aqui que a maioria dos integradores numéricos vai *amostrar* pontos na coordenada de integração segundo a *rigidez numérica* do problema, de maneira que a solução retornada normalmente não está sobre pontos equi-espaçados. Podemos fornecer um parâmetro opcional para recuperar a solução sobre os pontos desejados, o que pode facilitar, por exemplo, comparação com dados experimentais.

```julia; @example notebook
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

```julia; @example notebook
Tₐ = analyticalthermalpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)
Tₒ = solvemtkpfr(; pfr, P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)[:T]

Tend = @sprintf("%.2f", Tₐ[end])
yrng = (300, 400)

with_theme() do
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


Quando integrando apenas um reator, o método de integração numérica da equação é geralmente a escolha mais simples. No entanto, em situações nas quais desejamos integrar trocas entre diferentes reatores aquela abordagem pode se tornar
proibitiva. Uma dificuldade que aparece é a necessidade de solução iterativa até convergência dados os fluxos pelas paredes do reator, o que demandaria um código extremamente complexo para se gerir em integração direta. Outro caso são
trocadores de calor que podem ser representados por conjutos de reatores em contra-corrente, um exemplo que vamos tratar mais tarde nesta série. Nestes casos podemos ganhar em simplicidade e tempo de cálculo empregando métodos que *linearizam* o problema para então resolvê-lo por uma simples *álgebra linear*.

Na temática de fênomenos de transporte, o método provavelmente mais frequentemente utilizado é o dos volumes finitos (em inglês abreviado FVM). Note que em uma dimensão com coeficientes constantes pode-se mostrar que o método é equivalente à diferenças finitas (FDM), o que é nosso caso neste problema. No entanto vamos insistir na tipologia empregada com FVM para manter a consistência textual nos casos em que o problema não pode ser reduzido à um simples FDM.

No que se segue vamos usar uma malha igualmente espaçada de maneira que nossas coordenadas de solução estão em $z\in\{0,\delta,2\delta,\dots,N\delta\}$ e as interfaces das células encontram-se nos pontos intermediários. Isso dito, a
primeira e última célula do sistema são *meias células*, o que chamaremos de *condição limite imersa*, contrariamente à uma condição ao limite com uma célula fantasma na qual o primeiro ponto da solução estaria em $z=\delta/2$. Trataremos
esse caso em outra ocasião.

O problema de transporte advectivo em um reator pistão é essencialmente *upwind*, o que indica que a solução em uma célula $E$ *a leste* de uma célula $P$ depende exclusivamente da solução em $P$. Veremos o impacto disto na forma
matricial trivial que obteremos na sequência. Para a sua construção, começamos pela integração do problema entre $P$ e $E$, da qual se segue a separação de variáveis

$$
\int_{T_P}^{T_E}\rho{}u{}c_{p}A_{c}dT=
\int_{0}^{\delta}\hat{h}{P}(T_{s}-T^{\star})dz
$$


Observe que introduzimos a variável $T^{\star}$ no lado direito da equação e não sob a integral em $dT$. Essa escolha se fez porque ainda não precisamos definir qual a temperatura mais representativa deve-se usar para o cálculo do fluxo
térmico. Logo vamos interpretá-la como uma constante que pode ser movida para fora da integral

$$
\rho{}u{}c_{p}A_{c}\int_{T_P}^{T_E}dT=
\hat{h}{P}(T_{s}-T^{\star})\int_{0}^{\delta}dz
$$

Realizando-se a integração definida obtemos a forma paramétrica

$$
\rho{}u{}c_{p}A_{c}(T_{E}-T_{P})=
\hat{h}{P}\delta(T_{s}-T^{\star})
$$

Para o tratamento com FVM agrupamos parâmetros para a construção matricial, o que conduz à

$$
aT_{E}-aT_{P}=
T_{s}-T^{\star}
$$

No método dos volumes finitos consideramos que a solução é constante através de uma célula. Essa hipótese é a base para construção de um modelo para o parâmetro $T^{\star}$ na presente EDO. Isso não deve ser confundido com os esquemas de
interpolaçãO que encontramos em equações diferenciais parciais.

A ideia é simples: tomemos um par de células $P$ e $E$ com suas respectivas temperaturas $T_{P}$ e $T_{E}$. O limite dessas duas células encontra-se no ponto médio entre seus centros, que estão distantes de um comprimento $\delta$. Como a solução é constante em cada célula, entre $P$ e a parede o fluxo de calor total entre seu centro e a fronteira $e$ com a célula $E$ é

$$
\dot{Q}_{P-e} = \hat{h}{P}(T_{s}-T_{P})\delta_{P-e}=
\frac{\hat{h}{P}\delta}{2}(T_{s} - T_{P})
$$

De maneira análoga, o fluxo entre a fronteira $e$ e o centro de $E$ temos

$$
\dot{Q}_{e-E} = \hat{h}{P}(T_{s}-T_{E})\delta_{e-E}=
\frac{\hat{h}{P}\delta}{2}(T_{s}-T_{E})
$$


Nas expressões acima usamos a notação em letras minúsculas para indicar fronteiras entre células. A célula de referência* é normalmente designada $P$, e logo chamamos a fronteira pela letra correspondendo a célula vizinha em questão, aqui $E$. O fluxo convectivo total entre $P$ e $E$ é portanto

$$
\dot{Q}_{P-E}=\dot{Q}_{P-e}+\dot{Q}_{e-E}=
\hat{h}{P}\left[T_{s}-\frac{(T_{E}+T_{P})}{2}\right]
$$

de onde adotamos o modelo

$$
T^{\star}=\frac{T_{E}+T_{P}}{2}
$$

A troca convectiva com a parede não seria corretamente representada se escolhessemos $T_{P}$ como referência para o cálculo do fluxo (o que seria o caso em FDM). Obviamente aproximações de ordem superior são possíveis empregando-se mais de duas células mas isso ultrapassa o nível de complexidade que almejamos entrar no momento.

Aplicando-se esta expressão na forma numérica precedente, após manipulação chega-se à

$$
(2a + 1)T_{E}=
(2a - 1)T_{P} + 2T_{w}
$$

Com algumas manipulações adicionais obtemos a forma que será usada na sequência

$$
-A^{-}T_{P} + A^{+}T_{E}=1
\quad\text{aonde}\quad{}
A^{\pm} = \frac{2a \pm 1}{2T_{w}}
$$

A expressão acima é válida entre todos os pares de células $P\rightarrow{}E$ no sistema, exceto pela primeira. Como se trata de uma EDO, a primeira célula do sistema contém a condição inicial $T_{0}$ e não é precedida por nenhuma outra célula e evidentemente não precisamos resolver uma equação adicional para esta. Considerando o par de vizinhos $P\rightarrow{}E\equiv{}0\rightarrow{}1$, substituindo o valor da condição inicial obtemos a modificação da equação para a
condição inicial imersa

$$
A^{+}T_{1}=1 + A^{-}T_{0}
$$


Como não se trata de um problema de condições de contorno, nada é necessário para a última célula do sistema. Podemos agora escrever a forma matricial do problema que se dá por

$$
\begin{bmatrix}
 A^{+}  &  0     &  0     & \dots  &  0      &  0      \\
-A^{-}  &  A^{+} &  0     & \dots  &  0      &  0      \\
 0      & -A^{-} &  A^{+} & \ddots &  0      &  0      \\
\vdots  & \ddots & \ddots & \ddots & \ddots  & \vdots  \\
 0      &  0     &  0     & -A^{-} &  A^{+}  &   0     \\
 0      &  0     &  0     &  0     & -A^{-}  &   A^{+} \\
\end{bmatrix}
\begin{bmatrix}
T_{1}    \\
T_{2}    \\
T_{3}    \\
\vdots   \\
T_{N-1}  \\
T_{N}    \\
\end{bmatrix}
=
\begin{bmatrix}
1 + A^{-}T_{0}  \\
1               \\
1               \\
\vdots          \\
1               \\
1               \\
\end{bmatrix}
$$

A dependência de $E$ somente em $P$ faz com que tenhamos uma matriz diagonal inferior, aonde os $-A^{-}$ são os coeficientes de $T_{P}$ na formulação algébrica anterior. A condição inicial modifica o primeiro elemento do vetor
constante à direita da igualdade. A construção e solução deste problema é provida em `solvefvmpfr` abaixo.

```julia; @example notebook
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

```julia; @example notebook
data = readdlm("data/fluent-reference/postprocess.dat", Float64)
x, Tᵣ = data[:, 1], data[:, 2]

Tₐ = analyticalthermalpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)
Tₒ = solvemtkpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z, pfr)[:T]
Tₑ = solvefvmpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)

Tend = @sprintf("%.2f", Tₐ[end])
yrng = (300, 400)

with_theme() do
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

```julia; @example notebook
Tₐ = analyticalthermalpfr(; P, A, Tₛ, Tₚ, ĥ, u, ρ, cₚ, z)

Tend = @sprintf("%.2f", Tₐ[end])
yrng = (300, 400)

with_theme() do
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

## Conclusões


Com isso encerramos essa primeira introdução a modelagem de reatores do tipo pistão. Estamos ainda longe de um modelo generalizado para estudo de casos de produção, mas os principais blocos de construção foram apresentados. Os pontos principais a reter deste estudo são:

- A equação de conservação de massa é o ponto chave para a expansão e   simplificação das demais equações de conservação. Note que isso é uma consequência de qua a massa corresponde à aplicação do [Teorema de Transporte de Reynolds](https://pt.wikipedia.org/wiki/Teorema_de_transporte_de_Reynolds) sobre a *unidade 1*.

- Sempre que a implementação permita, é mais fácil de se tratar o problema como uma EDO e pacotes como ModelingToolkit proveem o ferramental básico para a construção deste tipo de modelos facilmente.

- Uma implementação em volumes finitos será desejável quando um acoplamento com   outros modelos seja envisajada. Neste caso a gestão da solução com uma EDO a parâmetros variáveis pode se tornar computacionalmente proibitiva, seja em   complexidade de código ou tempo de cálculo.

Isso é tudo para esta sessão de estudo! Até a próxima!