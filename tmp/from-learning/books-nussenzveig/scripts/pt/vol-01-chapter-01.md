# Introdução

## Captura 1 - Introdução a série

Bem-vindos à Física com Numericando! Nesta primeira série de estudos, vamos abordar de maneira simples e didática todo um curso de Física Básica. Nosso guia será a grande obra do Pr. Dr. Herch Moysés Nussenzveig. A escolha desse material nos pareceu bastante evidente dada a cobertura extensa de temas desde a Mecânica Clássica até a tópicos introdutórios da Mecânica Quantica. Poderíamos ter escolhido as [clássicas notas de aula de Feynman](https://www.feynmanlectures.caltech.edu/) ou então o [Curso de Física Teórica de Landau](https://en.wikipedia.org/wiki/Course_of_Theoretical_Physics), ambos cobrindo todo o campo que visavamos, mas com um nível de complexidade acima do esperado para essa série introdutória. Estão de fato em nossos planos de cobrir aquelas duas outras excelentes obras no futuro.

## Captura 2 - Métodos e ferramentas

Vamos abordar os tópicos de maneira minimalista, sem derivar todos os detalhes ou seguir a risca o conteúdo das referências. Você pode, afinal, consultá-las para capturar aqueles pontos que não detalharmos. A idéia aqui é de trazer uma Física conceitual com bastante interpretação de contexto e implicações das diferentes leis estudadas. Cada capítulo será abordado em um vídeo e novos episódios a cada duas semanas. Se você quer seguir nossa série para um estudo autodidata, a forma recomendada é assistir um vídeo e depois realizar a leitura do capítulo em questão antes de seguir a resolução dos exercícios. Hoje em dia, para ser um cientista completo não basta dominar os aspectos teóricos e matemáticos, mas um bom domínio de ferramentas computacionais é fundamental. É por isso que acompanhando as resoluções de exercícios vamos com frequência empregar [Jupyter Notebooks](https://jupyter.org/) para avaliação numérica e gráfica. De maneira arbitrária utilizaremos [Python](https://www.python.org/), [Julia](https://julialang.org/), ou outra linguagem adaptada a computação científica.

## Captura 3 - Física e Ciência

A Física não vive por si só: está fortemente emaranhada com as demais ciências e tecnologia. Podemos ilustrar como a Química em princípio é resultado das interações fundamentais entre orbitais eletrônicos nos átomos, um tópico abordado de uma maneira mais fundamental pela Física. Indo uma escala de complexidade acima, a Biologia é regida primordialmente por fenômenos de origem química e de transporte, o que no final converge na Física. Afinal, por que necessitamos então dessas várias camadas de abstração na Ciência? O alvo da Física é explicar os fenômenos mais fundamentais e intrísicos do nosso universo, mas quando tentamos generalizar para sistemas cada vez mais complexos, nossa capacidade de *computar* o mundo é colapsada pela nossa incapacidade de tomar as condições iniciais de um sistema de maneira completa. É por isso que a Física não pode viver só. Certamente aspectos estatísticos de sistemas complexos podem ser descritos pela Física e com suporte computacional estamos cada vez mais avançados nesse campo, mas uma descrição determinística de muitos problemas *específicos* escapa da nossa atual capacidade de avaliação.

## Captura 4 - O Método Científico

A característica básica de toda Ciência é o emprego de uma metodologia geral, o *Método Científico*. Esse método não codifica regras explícitas de como conduzir a pesquisa, mas fornece em linhas gerais o caminho entre a observação de sistemas até a construção de teorias para a Natureza. Um primeiro passo no *Método* é a **observação** do fênomeno, seja por via experimental ou em campo. São os fatos observados e tão somente esses fatos que devem fundamentar a construção teórica. Recomendo fortemente escutar a [mensage de Russel para as gerações futuras](https://www.youtube.com/watch?v=IJcqP9fGBSk), que está exatamente em fase com esses princípios. Com base nos fatos, o investigador pode estabelecer uma primeira **abstração** do problema. Por exemplo, ao estudarmos a rotação de um planeta sobre seu eixo, normalmente é aceitável de aproximá-lo como uma esfera perfeita para fins de aproximação matemática; quando estudando a translação ao redor de sua estrela, normalmente as distâncias envolvidas são tão grandes que representar o planeta como um ponto material é suficientemente preciso. É importante nesta etapa de restringir a complexidade dos fenômenos e reter a atenção em um tópico bastante preciso. Com esses elementos é possível então estabelecer **teorias** explicando o fenômeno, as quais são submetidas à uma última etapa de **validação**. Os testes mostram inviabilidade da teoria proposta? Repete! O Método Científico é intrinsecamente iterativo as as teorias, até onde conhecemos hoje, são aproximações ou casos especiais de aspectos mais gerais que são descobertos ao longo do tempo!

## Captura 5 - Medindo o Espaço

Como acabamos de ver, a prática do *Método* requer experimentação, o que implica medidas. Em Mecânica Clássica, tópico que vamos começar a abordar, isso implica fundamentalmente medidas de deslocamentos e intervalos de tempo. Logo, o estabelecimento de escalas e meios de medidas se faz necessário, e neste campo tudo é estabelecido por convenção. O *metro* que conhecemos já foi baseado na distância entre o Polo Norte ao Equador, passou por uma definição relativa a um múltiplo de comprimentos de onda de uma emissão do criptônio e finalmente foi definido relativamente ao tempo à través da definição da velocidade da luz ao vácuo. Essa sequência histórica mostra que progredimos a uma métrica cada vez mais fundamental e relativa à grandezas fundamentais da natureza. Como nosso universo possui dimensões características que abrangem cerca de 40 ordens de grandeza do raio nuclear ao raio do universo visível, é de se esperar que métodos diretos e indiretos sejam empregados para a avaliação de distâncias. Podemos avaliar distancias interestrelates por variações de luminosidade, medir objetos do cotidiano com réguas e outros métodos visuais diretos, ou utilisar princípios mais fundamentais como a difração de eletrons para estabelecer distancias interplanares em um cristal.

## Captura 6 - Medindo o Tempo

De forma análoga a medida do espaço, as medidas de tempo mais antigas foram baseadas em observáveis comuns à todos, como a duração de um dia ou o ciclo lunar. Com um pouco mais de atenção e experiêcia, fica claro também que a *periodicidade* das estações e das posições das estrelas implica o ciclo de um ano (solar). A grande dificuldade na experiência com o tempo é que sua medida é sempre relativa à comparação de relógios e não podemos demonstrar que intervalos idênticos medidos por um mesmo relógio sejam *de fato* iguais. Com o advento das grandes navegações surgiu a necessidade de medirmos mais precisamente latitudes para demarcar as novas terras e consequentemente um progresso importante foi feito na tecnologia de medida de tempo. Hoje em dia temos a disposição relógios baseados em emissões atômicas de grande precisão e o padrão primário de tempo NIST - F1 nos permite um erro de apenas um segundo à cada 20 milhões de anos! Tal como para a medida do espaço, os tempos característicos para a luz atravessar un núcleo atômico à idade do universo são separados por mais de 40 ordens de grandeza e os métodos de medida variam de formas indiretas à métodos eletrônicos e vão até datações baseadas em decaimentos radioativos.

## Captura 7 - Notas finais e exercícios

Agora que você já se iniciou na Ciência Física, aprofunde seus conhecimentos lendo o [Capítulo 1 do Curso de Física Básica - Vol. 1](https://www.blucher.com.br/curso-de-fisica-basica-vol-1_9788521207450) antes de prosseguir com a [resolução dos exercícios](../../notebooks/pt/vol-01-chapter-01.ipynb). Até a próxima!