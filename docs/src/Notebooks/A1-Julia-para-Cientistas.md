# Julia para Cientistas

Julia *from zero to hero* com uma abordagem para computação científica.

Antes de entrar realmente nos tópicos de estudo listados abaixo, vamos falar um pouco sobre alguns elementos básicos para se seguir a série em relação a linguagem de programação [Julia](https://julialang.org/). Os conteúdos aqui apresentados são uma extensão daqueles providos pela [JuliaAcademy](https://juliaacademy.com/) em seu [curso introdutório](https://github.com/JuliaAcademy/Introduction-to-Julia). O objetivo desta extensão é apresentar alguns elementos suplementares para a prática de computação científica. A temática de gráficos em Julia, será abordada em um tutorial distinto do curso no qual nos baseamos dada a necessidade de ir um pouco além na qualidade gráfica para publicações em *journals*.

Julia é uma linguagem sintaticamente similar à [Python](https://www.python.org/) mas o estilo de programação tipicamente adotado tende a ser procedural com uso de estruturas e métodos para processar dados contidos nestas. Esta nova linguagem publicada pela primeira vez em 2012 vem ganhando grante *momentum* e uma comunidade bastante interessante na sua diversidade científica. Após alguns anos hesitando em me engajar no seu uso para aplicações em pesquisa em desenvolvimento, em 2023 fui convencido que é chegada hora de transferir parte dos estudos em Julia e então adaptar todos os conteúdos que produzo nesta linguagem.

Recomenda-se o estudo do presente tutorial de forma interativa em uma longa seção de aproximadamente 4 horas de estudo. Após este primeiro contato, os tutorials mais complexos que se seguem se tornarão acessíveis mesmo para aqueles que estão tendo seu primeiro contato com computação. Este tutorial pode ao longo do estudo ser consultado para clarificar elementos da linguagem. Uma vez que se encontre confortável com o conteúdo aqui apresentado, recomenda-se estudar o [manual](https://docs.julialang.org/en/v1/manual/getting-started/) da linguagem, o qual apresenta detalhes omitidos nesta introdução almejada para um primeiro contato.

Julia possui um largo ecossistema de pacotes implementado uma vasta gama de funcionalidades. Para conhecer mais não deixe de visitar [Julia Packages](https://juliapackages.com/).

## Seguindo os materiais

Os conteúdos são majoritariamente sequenciais: exceto para os tópicos mais avançados (para aqueles que já programam em Julia), é necessário seguir os notebooks na ordem provida.

Um canal YouTube do curso está em fase de concepção para abordar os detalhes entre-linhas, involvendo aspectos que não necessariamente estão escritos.

Etapas à seguir para começar os estudos:

1. Ler sobre *ciência colaborativa* abaixo para se familiarizar com alguns elementos que vamos abordar no que se segue.

1. [Instalar Julia](https://julialang.org/downloads/) na versão estável para seu sistema operacional.

1. [Instalar Pluto](https://github.com/fonsp/Pluto.jl) para visualizar e editar os notebooks do curso.

1. Clonar este repositório com todos os materiais usando a seguinte ordem de prioridade:

    - Usando Git à través da linha de comando, forma recomendada com `git clone https://github.com/wallytutor/medium-articles.git`

    - Com a interface gráfica de [GitHub Desktop](https://desktop.github.com/)

    - Usando o botão de [Download](https://github.com/DryTooling/DryTooling.jl/archive/refs/heads/main.zip)

Caso a última opção de download tenha sido a sua escolha, observe que o arquivo `.zip` não contem os elementos de *repositório git* para controle de versão, implicando que as suas modificações e notas tomadas deverão ser geridas localmente, o que não é recomendável. Para estudantes ainda não familiarizados com *git*, a opção de utilizar GitHub Desktop é a mais apropriada.

## Ciência colaborativa

Uma dificuldade recorrente encontrada em projetos científicos contendo uma componente numérica é o despreparo dos colaboradores para a gestão de dados e documentos. Essa dificuldade não é somente técnica, mas frequentemente a origem de discórdias nos projetos.

O estudo de Julia ou qualquer outra ferramenta para suporte computacional em ciência não tem sentido sem o caráter aplicativo no contexto de um projeto, seja ele acadêmico ou industrial. Neste anexo vamos abordar algumas ferramentas complementares ao uso de Julia úteis para o cientista e apontar os caminhos para encontrá-las e aprender mais sobre elas sem entrar nos detalhes de seus usos. A lista provida não é exaustiva mas contém um esqueleto mínimo que toda pesquisa séria deveria adotar para prover materiais com controle de qualidade e versionagem adequada.

Para estudar aspectos computacionais em ciência você precisa de alguns componentes de suporte à linguagem de programação usada, em nosso caso Julia. No que se segue vamos apresentar:

- O editor de texto recomendado VS Code e a extensão requerida.
- A linguagem $\LaTeX$ usada para a entrada de equações nos notebooks e artigos.
- As ferramentas necessárias para editar $\LaTeX$ fora do contexto de Julia.
- E finalmente o sistema de versionagem Git.
- Outras ferramentas de suporte.

### VS Code

Nos últimos anos [VSCode](https://code.visualstudio.com/) se tornou o editor mais popular da comunidade *open source* e com toda razão. A qualidade da ferramenta provida pela Microsoft chegou a um nível que é difícil justificar o uso de um editor de código comercial. Aliado a isso, com a extensão [Julia VSCode](https://www.julia-vscode.org/) um suporte avançado a edição de código e documentação da linguagem é disponível. Além disso, a ferramenta provê [integração com o sistema de controle de versões Git](https://code.visualstudio.com/docs/sourcecontrol/overview) que vamos discutir no que se segue.

### $\LaTeX$

Para a entrada de equações nos notebooks, [Julia markdown](https://docs.julialang.org/en/v1/stdlib/Markdown/) provê suporte à renderização de $\LaTeX$. É fundamental ter algum domínio desta linguagem para a elaborção de documentos científicos. As distribuições mais populares são [MiKTeX](https://miktex.org/) para Windows e [TeX Live](https://tug.org/texlive/) para os demais sistemas operacionais. Ademais, artigos escritos usando a linguagem são aceitos pelas publicações mais relevantes em várias áreas do conhecimento. Outra razão para o uso de $\LaTeX$ é a estocagem de documentos em formato de texto bruto, o que permite um controle de versões com Git.

### TeXStudio

Em complemento à distribuição de $\LaTeX$ é necessário um editor de texto adaptado. Embora existam extensões excelentes para realizar a compilação dos documentos [^1] para VS Code, elas não são muito fáceis de se compreender para um iniciante. Por isso recomendamos [TeXStudio](https://www.texstudio.org/) para editar e compilar documentos escritos em $\LaTeX$.

[^1]: Por compilação entende-se em nossos dias transformar o documento em PDF.

### JabRef

Embora as referências bibliográficas possam ser inseridas diretamente em documentos $\LaTeX$, o ideal é utilizar uma base de dados comum que possa ser reutilizada ao longo da carreira de pesquisa. [JabRef](https://www.jabref.org/) é um gestor de bibliografia para o formato ``BibTeX`` suportado por $\LaTeX$ que estoca dados diretamente em formato textual. A interface gráfica é fácil de interagir e dado o formato de documento, as bases *.bib* são compatíveis com Git. 

### Git

Falamos bastante em [Git](https://git-scm.com/downloads) até o momento sem entrar em mais detalhes de que é uma ferramenta de controle de versões. Git elimina a prática insana de se salvar manualmente várias cópias de um mesmo documento para gerir versões. O sistema basea-se na comparação de conteúdos e propõe de se salvar unicamente os documentos modificados em um projeto. Embora seu uso básico seja bastante simples e plausível de se aprender em uma tarde de estudo, a ferramenta é bastante complexa e complexa, permitindo de voltar em pontos históricos de um projeto, publicar *releases*, etc. Para uma pesquisa sã e durável, o uso de documentos em formatos aceitando texto bruto em conjunto com Git é ideal.

### Python

Embora esse seja um curso de Julia, é importante que o cientista também tenha conhecimento de [Python](https://www.python.org/). Python é uma linguagem generalista que também é bastante rica em termos de pacotes para aplicações científicas. Em termos de aprendizado é relativamente mais simples que Julia, com o porém que código nativo em Python é extremamente lento, requerindo sempre o uso de bibliotecas que na verdade são implementadas em C, Fortran, Rust, etc. Para a concepção de aplicações web especialmente a linguagem encontra-se num estado de maturidade bastante superior à Julia e não deve ser negligenciada. Ademais, encontra-se entre as linguagens mais utilizadas no mundo, enquanto Julia é uma linguagem de nicho.

### GNUPlot

Embora tratemos da temática de gráficos para publicações no curso, uma alternativa sempre é interessante. [GNUPlot](http://www.gnuplot.info/) é uma ferramenta *open source* contando com sua própria linguagem para geração de gráficos. É uma ferramenta interessante principalmente quando se deseja padronizar todas as figuras em um projeto através de arquivos de configuração.

## Para aonde ir depois?

### Para aprender mais

[Julia Academy](https://juliaacademy.com/): nesta página encontram-se cursos abertos em várias temáticas comumente abordadas com a linguagem Julia. Você encontrará cursos parcialmente equivalentes aos materiais tratados aqui, mas também vários conteúdos que não são abordados nesta introdução, especialmente em tópicos ligados a Ciência de Dados.

[Introduction to Computational Thinking](https://computationalthinking.mit.edu/Fall23/): esse é provavelmente o melhor curso generalista para aplicações científicas da linguagem. O curso é ministrado inclusive pelo [Pr. Dr. Alan Edelman](https://en.wikipedia.org/wiki/Alan_Edelman) um dos criadores de Julia. Os tópicos abordados vão de tratamento de imagens, séries temporais, a resolução de equações diferenciais parciais.

[*SciML Book*](https://book.sciml.ai/): este livro é o resultado dos materiais de suporte do curso *Parallel Computing and Scientific Machine Learning (SciML): Methods and Applications* no MIT. Os tópicos são suportados por vídeo aulas e entram em mais profundidade nos assuntos avançados que tratamos aqui.

[Exercism Julia Track](https://exercism.org/tracks/julia): a plataforma *Exercism* propõe no percurso de Julia vários exercícios de algoritmos de nível fácil à intermediário-avançado. Minha recomendação é que essa prática venha a complementar os materiais propostos acima como forma de sedimentar o aprendizado da linguagem.

[Julia Data Science](https://juliadatascience.io/): este livro complementa tópicos mais operacionais de análise de dados, especialemente técnicas básicas de Ciência de Dados, que omitimos neste curso. Um bom material complementar aos estudos.

### Comunidade Julia

[Julia Community Zulipchat](https://julialang.zulipchat.com/): precisando de ajuda ou buscando um projeto para contribuir? Este chat aberto da comunidade Julia é o ponto de encontro para discutir acerca dos diferenter projetos e avanços na linguagem.

[Julia Packages](https://juliapackages.com/): o repositório mestre do índice de pacotes escritos na linguagem Julia ou provendo interfaces à outras ferramentas. A página contém um sistema de busca e um índice por temas.

[JuliaHub](https://juliahub.com/): esta plataforma comercial provê tudo que é necessário para se passar da prototipagem à escala industrial de soluções concebidas em Julia. Atualmente é a norma em termos de escalabilidade para a linguagem.

### Organizações recomendadas

[SciML](https://sciml.ai/): pacotes para *Machine Learning* científico.

[JuMP](https://jump.dev/): uma linguagem de optimização matemática em Julia.

[JuliaData](https://github.com/JuliaData): pacotes para *Data Science* em geral.

[JuliaMolSim](https://juliamolsim.github.io/): simulação de dinâmica molecular em Julia.

---

## Parte 1 - Primeiros passos

Tradicionalmente, o primeiro contato com uma linguagem de programação se faz através da implementação se seu programa `Hello, World!` que nada mas faz que imprimir esta sentença em um terminal. Em Julia usamos a função `println()` contendo o texto a ser apresentado entre aspas duplas (veremos mais sobre texto na próxima seção) para implementar este *programa*, como se segue:

```julia; @example notebook
println("Olá, Mundo!")
```

### Tipos básicos

O interesse principal de programação é o fato de podermos *atribuir* valores à *nomes* e em seguida realizar a manipulação necessária. Uma vez implementado o *algoritmo*, podemos simplesmente modificar os valores e *reutilizá-lo*.

Esse processo chama-se *atribuição de variáveis* e é realizado utilizando o símbolo de igualdade `=` com o nome da variável à esquerda e seu valor a direita.

!!! warn "Cuidado"

    Veremos mais tarde que a comparação de igualdade se faz com um duplo sinal `==` e que devemos tomar cuidado com isso quando estamos tendo um primeiro contato com programação. A igualdade simples `=` é, na maioria das linguagens modernas, um símbolo de atribuição de valor.

Vamos criar uma variávei `favorite_number_1` e atribuir seu valor:

```julia; @example notebook
favorite_number_1 = 13
```

Agora poderíamos realizar operações com `favorite_number_1`. Faremos isso mais tarde com outras variáveis porque antes é importante de introduzirmos o conceito de *tipos*. Toda variável é de um dado tipo de dado, o que implica o tamanho (fixo ou variável) de sua representação na memória do computador. Com a função `typeof()` inspecionamos o tipo de uma variável.

Vemos que o tipo de 13 -- um número inteiro -- é representado em Julia por `Int64`.

```julia; @example notebook
typeof(favorite_number_1)
```

Existem diversos [tipos numéricos suportados por Julia](https://docs.julialang.org/en/v1/base/numbers/), mas aqui vamos ver somente os tipos básicos utilizados mais comumente em computação numérica. Atribuindo um valor aproximado de π a `favorite_number_2` obtemos um *objeto* de tipo `Float64`, utilizado para representar números reais em *dupla precisão*.

!!! note "Aritmética de ponto flutuante de dupla precisão"

    A maioria dos números reais não podem ser representados com precisão arbitrária em um computador. Um número real em dupla precisão é representado com 64 bits na memória. Representações de precisão arbitrária são hoje em dia disponíveis mas tem um custo de operação proibitivo para a maioria das aplicações. A matemática necessária para a compreensão da representação na memória é discutida no livro texto.

```julia; @example notebook
favorite_number_2 = 3.141592
typeof(favorite_number_2)
```

Uma particularidade de Julia dado o seu caráter científico é o suporte à números irracionais. Podemos assim representar `π` de maneira otimizada como discutiremos num momento oportuno.

!!! note "Caracteres especiais"

    Julia suporta progração usando quaisquer caractéres UNICODE. Isso inclui letras gregas, subscritos, símbolos matemáticos... Em *notebooks* Pluto ou em editores conectados à um *Julia Language Server* podemos entrar esses símbolos digitando seu equivalente em ``\LaTeX`` e pressionando a tecla <TAB>. Uma lista detalhada de caracteres suportados é apresentada [aqui](https://docs.julialang.org/en/v1/manual/unicode-input/).


```julia; @example notebook
favorite_number_3 = π
typeof(favorite_number_3)
```

Por exemplo, também temos o número de Euler representado como irracional. Como este número é representado pela letra `e`, para evitar conflitos com outras variáveis ele precisa ser acessado pelo caminho completo do [módulo definindo](https://docs.julialang.org/en/v1/base/numbers/#Base.MathConstants.%E2%84%AF) as constantes matemáticas.

```julia; @example notebook
favorite_number_4 = MathConstants.e
typeof(favorite_number_4)
```

Outro exemplo de constante irracional é a proporção áurea.

```julia; @example notebook
Base.MathConstants.golden
```

A lista completa pode ser acessada com `names(module)` como se segue:

```julia; @example notebook
names(MathConstants)
```

O nome de variáveis também pode ser um emoji -- evite isso em programas, evidentemente.

```julia; @example notebook
🥰 = "Julia"
typeof(🥰)
```

Usando essa possibilidade podemos brincar com o conceito como abaixo:

```julia; @example notebook
🐶 = 1
😀 = 0
😞 = -1
# Vamos ver se a expressão a seguir é avaliada como verdadeira.
# Todo texto após um `#` é considerado um comentário por Julia.
# Abaixo vemos um novo operador de comparação de igualdade `==`.
🐶 + 😞 == 😀
```

### Comentários

Vimos no bloco acima o primeiro bloco de comentários identificado por linhas
iniciando com `#`. Como comentários não são expressões, vemos abaixo que
múltiplas linhas são aceitas em uma única célula contando que haja apenas uma
expressão no contexto. Comentários são desejáveis para que entendamos mais tarde
qual era o objetivo de uma dada operação. Confie em mim, anos mais tarde um
código que parecia evidente no momento da sua escritura, quando você tem o
conceito a ser expresso fresco na cabeça, pode parecer um texto em
[basco](https://pt.wikipedia.org/wiki/L%C3%ADngua_basca).

```julia; @example notebook
# Em Julia, toda linha começando por um `#` é considerada um
# comentário. Comentários após declarações também são possíveis:

comment = 1;  # Um comentário após uma declaração.

#=
Comentários de multiplas linhas também podem ser escritos usando
o par `#=` seguido de texto e então `=#` no lugar de iniciar
diversas linhas com `#`, o que torna sua edição mais fácil.
=#

nothing; #hide
```

### Aritmética básica

Podemos usar Julia em modo interativo como uma calculadora.

Vemos abaixo a adição `+` e subtração `-`,...

```julia; @example notebook
1 + 3, 1 - 3
```

... multiplicação `*` e divisão `/`, ...

```julia; @example notebook
2 * 5, 2 / 3
```

... e uma comparação entre a divisão racional e normal.

```julia; @example notebook
2 // 3 * 3, 2 / 3 * 3
```

Julia possui suporte incluso a números racionais, o que pode ser útil para
evitar propagação de erros em vários contextos aonde frações de números inteiros
podem eventualmente ser simplificadas. Verificamos o tipo da variável com
`typeof()`.

```julia; @example notebook
typeof(2 // 3)
```

O quociente de uma divisão inteira pode ser calculado com a função `div()`. Para
aproximar essa expressão da notação matemática é também possível utilizar `2 ÷
3`.

```julia; @example notebook
div(2, 3)
```

O resto de uma divisão pode ser encontrado com `mod()`. Novamente essa função
possui uma sintaxe alternativa -- como em diversas outras linguagem nesse caso
-- utilizando o símbolo de percentual como em `11 % 3`.

```julia; @example notebook
mod(11, 3)
```

Para concluir as operações básicas, incluímos ainda a expoenciação `^`.

```julia; @example notebook
2^5
```

Outra particularidade de Julia é o suporte à multiplicação implícita -- use essa
funcionalidade com cuidado, erros estranhos podem ocorrer em programas
complexos.

```julia; @example notebook
a_number = 234.0;
2a_number
```

O valor de π também pode ser representado por `pi`. Observe que a multiplicação
de um inteiro `2` por `pi` (de tipo `Irrational{:π}`) produz como resultado um
número `Float64`.

```julia; @example notebook
typeof(2pi)
```

### Conversão explícita

Se um número real pode ser representado por um tipo inteiro, podemos utilizar a função `convert()` para a transformação desejada. Caso a representação integral não seja possível, talvez você possa obter o resultado almejado usando uma das funções `round()`, `floor()`, ou `ceil()`, as quais você pode verificar na documentação da linguagem.

```julia; @example notebook
a_number = 234.0;
convert(Int64, a_number) == 234
```

Funções em Julia também podem ser aplicadas a múltiplos argumentos de maneira sequencial em se adicionando um ponto entre o nome da função e o parêntesis de abertura dos argumentos. Por exemplo, para trabalhar com cores RGB é usual empregar-se o tipo `UInt8` que é limitado à 255, reduzindo a sua representação em memória.

A conversão abaixo se aplica a sequência de números `color` individualmente.

```julia; @example notebook
color = (255.0, 20.0, 21.0)
convert.(UInt8, color)
```

Finalmente, formas textuais podem ser interpretadas como números usando `parse()`.

```julia; @example notebook
parse(Int64, "1")
```

---

## Parte 2 - Manipulação textual

Uma habilidade frequentemente negligenciada pelo grande público de computação científica nos seus primeiros passos é a capacidade de manipulação textual. Não podemos esquecer que programas necessitam interfaces pelas quais alimentamos as condições do problema a ser solucionado e resultados são esperados ao fim da computação. Para problemas que tomam um tempo computacional importante, é extremamente útil ter mensagens de estado de progresso. Nessa seção introduzimos os primeiros elementos necessários para a manipulação textual em Julia.

Uma variável do tipo `String` declara-se com aspas duplas, como vimos inicialmente no programa `Hello, World!`. Deve-se tomar cuidado em Julia pois caracteres individuais (tipo `Char`) tem um significado distinto de uma coleção de caracteres `String`.

Por exemplo, avaliando o tipo de `'a'` obtemos:

```julia; @example notebook
typeof('a')
```

### Declaração de Strings

Estudaremos caracteres mais tarde. Por enquanto nos interessamos por expressões como:

```julia; @example notebook
text1 = "Olá, eu sou uma String"

typeof(text1)
```

Eventualmente necessitamos utilizar aspas duplas no interior do texto. Neste caso, a primeira solução provida por Julia é utilizar três aspas duplas para a abertura e fechamento do texto. Observamos abaixo que o texto é transformado para adicionar uma barra invertida antes das aspas que estão no corpo do texto.

```julia; @example notebook
text2 = """Eu sou uma String que pode incluir "aspas duplas"."""
```

Neste caso, Julia aplicou automaticamente um *caractere de escape* no símbolo a ser interpretado de maneira especial. Existem diversos casos aonde a aplicação manual pode ser útil, por exemplo quando entrando texto em UNICODE por códigos. No exemplo abaixo utilizamos a técnica manual com o texto precedente.

```julia; @example notebook
text3 = "Eu sou uma String que pode incluir \"aspas duplas\"."
```

Para averiguar o funcionamento correto, testamos de imprimir `text3` no terminal.

```julia; @example notebook
println(text3)
```

O exemplo a seguir ilustra o uso do caracter de escape para representar UNICODE.

```julia; @example notebook
pounds = "\U000A3"
```

### Interpolação de Strings

Para gerar mensagens automáticas frequentemente dispomos de um texto que deve ter partes substituidas. Ilustramos abaixo o uso de um símbolo de dólar \$ seguido de parêntesis com a variável de substituição para realizar o que chamamos de *interpolação textual*.

!!! note "Múltiplas variáveis em uma linha"

    Observe aqui a introdução da declaração de múltiplas variáveis em uma linha.

```julia; @example notebook
name, age = "Walter", 34
println("Olá, $(name), você tem $(age) anos!")
```

!!! warn "Prática não recomendada"

    Para nomes simples de variáveis e sem formatação explícita, o código a seguir também é valido, mas é pode ser considerado uma má prática de programação.

```julia; @example notebook
println("Olá, $name, você tem $age anos!")
```

Em alguns casos, como na contagem de operações em um laço, podemos também realizar operações e avaliação de funções diretamente na `String` sendo interpolada.

```julia; @example notebook
println("Também é possível realizar operações, e.g 2³ = $(2^3).")
```

### Formatação de números

```julia; @example notebook
using Printf

println(@sprintf("%g", 12.0))

println(@sprintf("%.6f", 12.0))

println(@sprintf("%.6e", 12.0))

println(@sprintf("%15.8e %15.8E", 12.0, 13))

println(@sprintf("%6d", 12.0))

println(@sprintf("%06d", 12))
```

### Concatenação de Strings

Na maioria das linguagens de programação a concatenação textual se faz com o símbolo de adição `+`. Data suas origens já voltadas para a computação numérica, Julia adota para esta finalidade o asterísco `*` utilizado para multiplicação, o que se deve à sua utilização em álgebra abstrata para indicar operações não-comutativas, como clarificado no [manual](https://docs.julialang.org/en/v1/manual/strings/#man-concatenation).

```julia; @example notebook
bark = "Au!"

bark * bark * bark
```

O circunflexo `^` utilizado para a exponenciação também pode ser utilizado para uma repetição múltipla de uma data `String`.

```julia; @example notebook
bark^10
```

Finalmente o construtor `string()` permite de contactenar não somente `Strings`, mas simultanêamente `Strings` e objetos que suportam conversão textual.

```julia; @example notebook
string("Unido um número ", 10, " ou ", 12.0, " a outro ", "texto!")
```

### Funções básicas

Diversos outros [métodos](https://docs.julialang.org/en/v1/base/strings/) são disponíveis para Strings. Dado o suporte UNICODE de Julia, devemos enfatizar com o uso de `length()` e `sizeof()` que o comprimento textual de uma `String` pode não corresponder ao seu tamanho em *bytes*, o que pode levar ao usuário desavisado a erros numa tentativa de acesso à caracteres por índices.

```julia; @example notebook
length("∀"), sizeof("∀")
```

Uma função que é bastante útil é `startswith()` que permite verificar se uma `String` inicia por um outro bloco de caracteres visado. Testes mais complexos podem ser feitos com [expressões regulares](https://docs.julialang.org/en/v1/base/strings/#Base.Regex), como veremos mais tarde.

```julia; @example notebook
startswith("align", "al")
```

---

## Parte 3 - Estruturas de dados I

Nesta seção vamos estudar alguns tipos de estruturas de dados. Essas formas *compostas* são construídas sobre elementos que já vimos mas podem também ir além destes. Abordaremos apenas as características básicas de cada uma das estruturas apresentadas e os casos de aplicação se tornarão evidentes. Os diversos métodos comuns à essas coleções é descrito [nesta página](https://docs.julialang.org/en/v1/base/collections/).

### *Tuples*

Uma *tuple* é constituída de uma sequência de elementos, que podem ser de tipos diferentes, declarada entre parêntesis. A característica de base de uma *tuple* é sua imutabilidade: uma vez declarada, seus elementos não podem ser alterados.

!!! note "Já vimos isso antes"

    Voltando a seção aonde realizamos a conversão explícita de tipos acima, você pode verificar que na realidade já utilizamos uma tuple de números indicando as intensidades RGB de uma cor.

Declaremos uma sequência fixa de linguagens de programação dadas por seus nomes como `Strings`:

```julia; @example notebook
languages = ("Julia", "Python", "Octave")
```

Inspecionando o tipo desta variável aprendemos mais uma característica importante inerente a definição de `Tuple` feita acima quanto ao seu caráter imutável: o tipo de uma `Tuple` inclui individualmente o tipo de cada um de seus elementos. Dito de outra maneira, uma sequência composta de um número definido de objetos de dados tipos caracteriza por ela mesmo um novo tipo de dados.

```julia; @example notebook
typeof(languages)
```

Os elementos de uma `Tuple` podem ser acessados por seus índices.

!!! warn "Indices em Julia"
    
    É o momento de mencionar que em Julia a indexação inicia com `1`.

```julia; @example notebook
@show languages[1]
```

Vamos tentar modificar o segundo elemento da `Tuple`.

!!! note "Sintaxe de controle de erros"

    Ainda é cedo para entrar nos detalhes, mas aproveite o bloco abaixo para ter um primeiro contato com a gestão de erros em Julia.

```julia; @example notebook
try
    languages[2] = "C++"
catch err
    println("Erro: $(err)")
end
```

Existem certas subtilidades que você precisa saber sobre a imutabilidade. Observe o exemplo abaixo, aonde declaramos duas variáveis que são utilizadas para construir uma `Tuple` e então modificamos uma das variáveis: a `Tuple` continua com os valores originais do momento da sua construção.

```julia; @example notebook
let
    a = 1
    b = 2

    test_tuple = (a, b)

    a = 5
    test_tuple
end
```

!!! warn "Isso nem sempre é verdade!"

    Se o elemento compondo a `Tuple` for de um tipo mutável, como é o caso de `Array`'s, como veremos no que se segue, os elementos desta variável podem ser modificados e impactam a `Tuple` diretamente. Isso se dá porque neste caso a `Tuple` conserva a referência ao objeto em questão, e não uma cópia dos valores, como é o caso para tipos de base.

```julia; @example notebook
let
    a = 1
    b = [1, 2]

    test_tuple = (a, b)

    b[1] = 999
    test_tuple
end
```

### *Named tuples*

Esta extensão à `Tuples` adiciona a possibilidade de acesso aos componentes por um *nome* no lugar de um simples índice -- que continua funcional como veremos abaixo. Esse tipo de estrutura é bastante útil quando necessitamos criar abstrações de coisas bastante simples para as quais a criação de um novo tipo não se justifica. Discutiremos mais tarde quando vamos estudar a criação de *novos tipos*.

```julia; @example notebook
named_languages = (julia = "Julia", python = "Python")
```

Observe o fato de que agora os nomes utilizados no índex fazem parte do tipo.

```julia; @example notebook
typeof(named_languages)
```

Abaixo verificamos que além do acesso por nomes, `NamedTuples` também respeitam a ordem de declaração dos elementos: `:julia` é o primeiro índice. A sintaxe de acesso aos elementos neste caso é com a notação típica utilizando um ponto, comum a diversas linguages de programação.

```julia; @example notebook
named_languages[1] == named_languages.julia
```

### Dicionários

Objetos do tipo `Dict` possuem a similaridade com `NamedTuples` em que seus elementos podem ser acessados por nome. No entanto a sintaxe é diferente e os valores desta estrutura são mutáveis.

```julia; @example notebook
organs = Dict("brain" => "🧠", "heart" => "❤")
```

O acesso a elementos se faz com colchetes contendo o índex como se segue:

```julia; @example notebook
organs["brain"]
```

E como dissemos, os elementos são mutáveis: vamos atribuir um burrito ao cérebro.

```julia; @example notebook
organs["brain"] = "🌯"
```

Não só os elementos, mas o dicionário como um todo, pode ser alterado. Para adicionar novos elementos simplesmente *acessamos* a palavra-chave e atribuímos um valor:

```julia; @example notebook
organs["eyes"] = "👀"
```

Internamente para evitar nova alocação de memória a cada tentativa de se adicionar um novo elemento, um dicionário realiza a alocação de `slots` que são renovados cada vez que sua capacidade é ultrapassada. Observe que a lista retornada abaixo é composta majoritariamente de `0x00`, que é o endereço de memória nulo, enquanto 3 elementos indicam um valor não-nulo, correspondendo aos elementos já adicionados ao dicionário. Disto vemos que adicionalmente um dicionário não preserva necessariamente uma sequência ordenada. Esses detalhes ultrapassam o presente escopo mas vão abrindo as portas para assuntos mais complexos.

```julia; @example notebook
organs.slots
organs
```

Para remover elementos utilizamos a função `pop!`. Por convenção em Julia, funções que terminam por um ponto de exclamação modificam os argumentos que são passados. No caso de `pop!` o dicionário é modificado e o valor de retorno é aquele do elemento removido.

```julia; @example notebook
pop!(organs, "brain")
```

A tentativa de remover um elemento inexistente obviamente conduz à um erro:

```julia; @example notebook
try
    pop!(organs, "leg")
catch err
    println("Erro: $(err)")
end
organs
```

Para evitar essa possibilidade podemos usar a função `haskey()`.

```julia; @example notebook
haskey(organs, "liver")
```

Uma última coisa a notar é que *praticamente* qualquer tipo básico pode ser empregado como a chave de um dicionário em Julia. Veja o exemplo à seguir:

```julia; @example notebook
music = Dict(:violin => "🎻", 1 => 2)
```

Como as chaves são de tipos diferentes (um `Symbol` e um `Int64`), assim como os valores (uma `String` e um `Int64`), a função `typeof()` nos retorna tipos `Any`.

```julia; @example notebook
typeof(music)
```

Ainda nos restam alguns detalhes e tipos de dados, mas o tutorial começa a ficar longo... e não queremos te perder por aqui!

---

## Parte 4 - Estruturas de dados II

Neste notebook estudamos a sequência de estruturas de dados básicas iniciada no precedente. O foco aqui são tipos úteis em cálculo numérico e álgebra linear, embora suas aplicação vaiam muito além.

### *Arrays*

A estrutura `Array` se diferencia de `Tuple` pelo fato de ser mutável e de `Dict` pela noção de ordem. Dadas essas características não é surpreendente que seja esse o tipo de base sobre o qual Julia constrói vetores e matrizes, embora um `Array` seja mais genérico que esses conceitos matemáticos. Podemos, por exemplo, construir um `Array` contendo sub-`Array`'s de tamanho variável, o que não constituiria uma matriz. Ou então misturar tipos de dados nos elementos de um `Array`, como mostramos ser possível com `Tuple`.

Em termos de sintaxe, usamos nesse caso colchetes `[]` para limitar a sequência.

Considere por exemplo a seguinte lista de países...

```julia; @example notebook
countries = ["France", "Brazil", "Germany"]
```

...ou então de números,...

```julia; @example notebook
numbers = [1, 2, 3.1]
```

..., ou simplesmente informações pessoais.

```julia; @example notebook
personal_info = ["Walter", 34, "Lyon"]
```

O acesso a elementos se faz através de índices, como em `Tuple`.

```julia; @example notebook
personal_info[2]
```

Como essa estrutura é mutável ela suporta -- [entre muitos outros](https://docs.julialang.org/en/v1/base/arrays/) -- o método `push!()` para se adicionar um elemento após o último.

```julia; @example notebook
push!(personal_info, "Engineer")
```

De maneira similar ao que vimos para `Dict`, uma implementação de `pop!()` é disponível para o tipo `Array`, realizando a operação inversa de `push!()`.

```julia; @example notebook
pop!(personal_info)
```

O exemplo de uma *não-matriz* citado na introdução é apresentado a seguir.

```julia; @example notebook
not_a_matrix = [[1, 2, 3], [4, 5], [6, 7, 8, 9]]
```

Usando `typeof()` descobrimos que se trata de um `Vector` de `Vector` e que na verdade Julia usa `Vector` com um *alias* para um `Array{T, 1}`, aonde `T` denota o tipo de dado.

```julia; @example notebook
typeof(not_a_matrix)
```

A função [`rand()`](https://docs.julialang.org/en/v1/stdlib/Random/#Base.rand) pode ser usada para criar uma matriz de números aleatórios -- e outras estruturas de ordem superior -- como se segue. Observe o tipo `Matrix{Float64}` indicado.

```julia; @example notebook
a_matrix = rand(3, 3)
```

Repetindo a verificação de tipo como fizemos para of *vetor de vetores* anteriormente, descobrimos que uma `Matrix` em Julia não é interpretada da mesma maneira, mas como um `Array` com duas dimensões. Isso é a forma que a linguagem emprega para assegurar as dimensões constantes segundo cada direção da matriz.

```julia; @example notebook
typeof(a_matrix)
```

Vamos agora atribuir nossa `a_matrix` à uma outra variável e então modificar a matrix original.

```julia; @example notebook
maybe_another_matrix = a_matrix
a_matrix[1, 1] = 999
a_matrix
```

Tal como para a `Tuple` com objetos mutáveis, atribuir um novo nome à uma matriz não cria uma nova matriz, apenas referencia o seu endereço de memória: observamos abaixo que a tentativa de cópia `maybe_another_matriz` também é modificada em razão da operação sobre `a_matrix`.

```julia; @example notebook
maybe_another_matrix
```

Quando uma cópia da matriz é necessária devemos utilizar `copy()`. Nas próximas células criamos uma matriz e então uma cópia, a qual é modificada, e verificamos não haver impacto na matriz original, validando a cópia em um novo endereço de memória.

```julia; @example notebook
another_matrix = rand(2, 2)
again_a_matrix = copy(another_matrix)
again_a_matrix[1, 2] = 0
again_a_matrix
another_matrix
```

### *Ranges*

Julia implementa uma variedade de tipos de *ranges*, iteradores para enumerações ou números espaçados segundo uma regra definida. Os tipos existentes encontram-se documentados em [collections](https://docs.julialang.org/en/v1/base/collections/). O leitor pode interessar-se também pela função mais genérica [range](https://docs.julialang.org/en/v1/base/math/#Base.range) da biblioteca padrão.

Vamos começar com a declaração de um `UnitRange` de números 1 à 10 que pode ser construido com a sintaxe simplificada abaixo.

```julia; @example notebook
range_of_numbers = 1:10
```

Confirmamos que trata-se de um `UnitRange` especializado para o tipo inteiro da arquitetura do computador, 64-bits, tal como o tipo dos elementos usados na construção.

```julia; @example notebook
typeof(range_of_numbers)
```

Essa sintaxe mostrada acima é simplesmente um *syntatic sugar* para a chamada do construtor padrão deste tipo, como averiguamos na próxima célula.

```julia; @example notebook
UnitRange(1, 10)
```

Uma particularidade da sequência criada é que ela não é expandida na memória, mas tão somente a regra de construção para iteração é definida. Verificamos na próxima célula que esta sequência não possui os elementos que esperaríamos.

```julia; @example notebook
range_of_numbers
```

Isso é fundamental para se permitir laços de tamanhos enormes, frequentes em computação científica; pode-se, por exemplo, criar uma sequência inteira entre 1 e o máximo valor possível para o tipo `Int64`:

```julia; @example notebook
1:typemax(Int64)
```

Para se expandir a sequência devemos *coletar* seus valores com `collect`:

```julia; @example notebook
arr = collect(range_of_numbers)
```

O resultado dessa operação é um `Vector` especializado no tipo usado para a sequência.

```julia; @example notebook
typeof(arr)
```

A inserção de um elemento adicional na sintaxe do tipo `start:step:end` permite a criação de sequências com um passo determinado. Abaixo usamos um passo de tipo `Float64` que por razões de precedência numérica vai gerar uma sequência de tipo equivalente, como verificamos no que se segue.

```julia; @example notebook
float_range = 0:0.6:10
typeof(float_range)
```

Acima utilizamos um passo de `0.6` para ilustrar uma particularidade do tipo `StepRangeLen` que não inclui o último elemento da sequência caso esse não seja um múltiplo inteiro do passo utilizado, de maneira a assegurar que todos os elementos sejam igualmente espaçados.

```julia; @example notebook
collect(float_range)
```

Finalmente, Julia provê `LinRange`, que será bastante útil para aqueles interessados em métodos numéricos de tipo diferenças finitas ou volumes finitos. Criamos um `LinRange` fornecendo os limites do intervalo e o número de elementos igualmente espaçados a retornar.

```julia; @example notebook
LinRange(1.0, 10.0, 10)
```

### Atribuição de tipos

Até o momento criamos objetos em Julia sem *anotar* os tipos de dados requeridos. O compilador de Julia realiza inferência de tipos de maneira bastante avançada para determinar como especializar funções para as entradas dadas. Prover explicitamente tipos, principalmente em interfaces de funções, como veremos no futuro, é altamente recomendável e evita dores de cabeça quanto a validação de um programa quando este ganha em complexidade. Ademais, para computação numérica e aprendizado de máquina, a especificação de tipos tem implicação direta sobre a precisão e performance dos cálculos. É comum, por exemplo, treinar-se redes neurais com dados truncados à `Float32`, tipo que apresenta performance optimizada nas GPU's específicas deste ramo, enquanto um cálculo DEM (Discrete Element Method) de colisão de partículas necessida dados `Float64` (e uma carta gráfica de alto nível adaptada) para prover resultados realistas.

Em Julia especificamos tipos com a sintaxe `a::TipoDeA`. Isso é valido para variáveis quaisquer, elementos de estruturas de dados, interfaces de funções, etc. Por exemplo, declaremos a seguinte variável:

```julia; @example notebook
a::Float32 = 1
typeof(a)
```

Anotamos o tipo `Float32` para a variável `a`. No entanto o argumento à direita do sinal de atribuição é um inteiro `1`. Se deixássemos a *descoberta* de tipos ao compilador, neste caso obteríamos:

```julia; @example notebook
a = 1
typeof(a)
```

Esse resultado pode ser indesejável e incompatível com a interface de alguma função aonde desejamos empregar o valor de `a`.

Vejamos agora alguns exemplos do impacto no tempo de execução de se prover valores ao lado *direito da igualdade* adaptados aos tipos esperados na especificação de dados. Vamos usar os *ranges* que aprendemos logo acima e `collect` para criar um `Vector{Int64}`.

!!! note "Uso de macros"

    A *macro* `@benchmark` vai executar o código algumas vezes e retornar estatísticas de execução. Não se preocupe com ela por agora, vamos voltar na temática de *benchmarking* muito em breve.

```julia; @example notebook
using BenchmarkTools, Statistics
@benchmark a::Vector{Int64} = collect(1:10)
```

Vemos que o tempo de execução é da ordem de 30 ns. Abaixo repetimos essa avaliação para algumas ordens de grandeza de tamanho de *arrays*. Vemos que o tempo de execução para a criação dos objetos escala com o logaritmo na base 10 do número de elementos.

```julia; @example notebook
scalability = [
    mean((@benchmark a::Vector{Int64} = collect(1:10^1)).times)
    mean((@benchmark a::Vector{Int64} = collect(1:10^2)).times)
    mean((@benchmark a::Vector{Int64} = collect(1:10^3)).times)
    mean((@benchmark a::Vector{Int64} = collect(1:10^4)).times)
]
log10.(scalability)
```

Tentemos agora criar um vetor de `Float64` usando o mesmo método.


```julia; @example notebook
@benchmark a::Vector{Float64} = collect(1:10)
```

O tempo de execução mais que dobrou e a memória estimada foi multiplicada por dois! Isso ocorre porque ao lado direito da expressão fornecemos números inteiros e o compilador é *obrigado* a incluir uma etapa de conversão de tipos, o que adiciona operações e alocações de memória.

Se na criação do *range* utilizarmos o tipo esperado de dados voltamos a linha de base da alocação do vetor de inteiros, da ordem de 30 ns e 144 bytes.

```julia; @example notebook
@benchmark b::Vector{Float64} = collect(1.0:10.0)
```

Repetimos o *benchmark* para comparar a criação de vetores de dupla-precisão inicializados por inteiros e números de dupla precisão. Incluímos no novo *benchmark* um vetor com um único elemento para entendermos um pouco mais do processo.

```julia; @example notebook
with_conversion = let
    scalability = [
        mean((@benchmark a::Vector{Float64} = collect(1:10^0)).times)
        mean((@benchmark a::Vector{Float64} = collect(1:10^1)).times)
        mean((@benchmark a::Vector{Float64} = collect(1:10^2)).times)
        mean((@benchmark a::Vector{Float64} = collect(1:10^3)).times)
    ]
    scalability
end
```

```julia; @example notebook
without_conversion = let
    scalability = [
        mean((@benchmark a::Vector{Float64} = collect(1.0:10.0^0)).times)
        mean((@benchmark a::Vector{Float64} = collect(1.0:10.0^1)).times)
        mean((@benchmark a::Vector{Float64} = collect(1.0:10.0^2)).times)
        mean((@benchmark a::Vector{Float64} = collect(1.0:10.0^3)).times)
    ]
    scalability
end
```

O vetor `with_conversion` contém os tempos de execução para a criação de vetores de 1, 10, 100, 1000 e 10000 elementos com conversão de valores de inteiros para dupla-precisão. Observe que os dois primeiros elementos levaram um tempo (aqui em nano-segundos) quase idênticos: existe uma constante de tempo da criação do vetor propriamente dito, a criação dos 10 primeiros elementos é quase negligível nesse caso.

Abaixo calculamos a diferença de tempo entre os dois processos e nos deparamos com mais uma surpresa: para 100 elementos, o tempo de alocação COM conversão é MENOR que o tempo SEM conversão. Ainda é muito cedo e fora de contexto para entrarmos no código LLVM gerado por Julia para entendermos a razão dessa *anomalia*. O importante a reter aqui é que para vetores de tamanhos importantes (> 1000 elementos) um tempo adicional de execução é adicionado por elemento e isso deve ser levado em conta quando escrevendo código científico.

```julia; @example notebook
time_diff = (without_conversion - with_conversion)
time_diff_per_element = time_diff ./ [10^k for k = 0:3]
```

Espero que a decisão de incluir essas divagações um pouco cedo no aprendizado não sejam deletérias para a motivação do estudante, mas que criem curiosidade quanto aos tópicos mais avançados que veremos mais tarde.

Ainda falta muito para se concluir a introdução à atribuição de tipos, mas esse primeiro contato era necessário para que as próximos tópicos avancem de maneira mais fluida.

---

## Parte 5 - Laços e condicionais

---

## Parte 6 - Funções e despacho

---

## Parte 7 - Pacotes e ecossistema

---

## Parte 8 - Avaliando performance

---

## Parte 9 - Álgebra linear

---

## Parte 10 - Expressões regulares

---

## Parte 11 - Execução concorrente

---

## Parte 12 - Trabalhando com arquivos

---

## Parte 13 - Bibliotecas gráficas

---

## Parte 14 - Gráficos para publicações

---

## Parte 15 - Tipos e estruturas

---

## Parte 16 - Metaprogramação

---

## Parte 17 - Interoperação com C

---

## Criando conteúdos

- Weave
- Franklin
- Pluto
- [Quarto](https://quarto.org/)
