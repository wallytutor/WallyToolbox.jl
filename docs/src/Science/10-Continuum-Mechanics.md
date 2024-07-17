# Reatores pistão

#plug-flow

Escoamentos nos quais a componente axial do transporte por advecção é dominante sobre o transporte difusivo aproximam-se do comportamento dito *pistão*. Neste caso o *número de Péclet* (ver [DryTransport](../Modules/DryTransport.md) para mais detalhes) tende ao infinito.

A temática de reatores pistão apresenta grande interesse para o cientista e engenheiro dados os fatos de que (1) frequentemente instalações experimentais no laboratório podem ser caracterizadas como estando neste regime limite e (2) com a composição de reatores pistão e agitados é possível compor modelos de reatores mais complexos de utilidade industrial. A introdução desenvolvida aqui parte da apresentação feita por ([[@Kee2017]]) para então desenvolver uma abordagem algorítmica para solução de reatores quaisquer. A abordagem de engenharia de reatores empregando modelos compostos não será apresentada, o leitor interessado podendo encontrá-la em ([[@Fogler1999]]).

## Um primeiro modelo

Para a introdução do tópico vamos aborda o estabelecimento do modelo e as equações de conservação necessárias. No presente caso, isso será feiro na ausência de reações químicas e trocas de matéria com o ambiente - o reator é um *tubo* fechado - precisamos estabelecer a conservação de massa e energia apenas. Como dito, o reator em questão conserva a massa transportada, o que é matematicamente expresso pela ausência de variação axial do fluxo de matéria, ou seja

$$
\frac{d(\rho{}u)}{dz}=0
$$

Mesmo que trivial, esse resultado é frequentemente útil na simplificação das outras equações de conservação para um reator pistão, como veremos (com frequência) mais tarde.

Embora não trocando matéria com o ambiente a través das paredes, vamos considerar aqui trocas térmicas. Afinal não parece muito útil um modelo de reator sem trocas de nenhum tipo nem reações. Da primeira lei da Termodinâmica temos que a taxa de variação da energia interna $E$ é igual a soma das taxas de trocas de energia $Q$ e do trabalho realizado $W$.

$$
\frac{dE}{dt}= \frac{dQ}{dt}+ \frac{dW}{dt}
$$

Podemos reescrever essa equação para uma seção transversal do reator de área $A_{c}$ em termos das grandezas específicas e densidade $\rho$ com as integrais

#divergence-theorem

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

Nos resta ainda determinar $\dot{Q}$. O tipo de interação com ambiente, numa escala macroscópica, não pode ser representado por leis físicas fundamentais. Para essa representação necessitamos de uma *lei constitutiva* que modela o fenômeno em questão. Para fluxos térmicos convectivos à partir de uma parede com temperatura fixa $T_{s}$ a forma análoga a uma condição limite de Robin expressa o $\dot{Q}$ como

$$
\dot{Q}=\hat{h}A_{s}(T_{s}-T)=\hat{h}(Pdz)(T_{s}-T)
$$

O coeficiente de troca térmica convectiva $\hat{h}$ é frequentemente determinado à partir do tipo de escoamento usando fórmulas empíricas sobre o número de Nusselt. A abordagem desse tópico vai além do nosso escopo e assume-se que seu valor seja conhecido. Nessa expressão já transformamos a área superficial do reator $A_{s}=Pdz$ o que nos permite agrupar os resultados em

$$
\int_{V}\nabla\cdotp(\rho{}h\mathbf{V})dV=
\hat{h}(Pdz)(T_{w}-T)
$$

Em uma dimensão $z$ o divergente é simplemente a derivada nessa coordenada. Usando a relação diverencial $\delta{}V=A_{c}dz$ podemos simplificar a equação para a forma diferencial como se segue

$$
\frac{d(\rho{}u{}h)}{dz}=
\frac{\hat{h}Pdz}{\delta{}V}(T_{w}-T)
\implies
\frac{d(\rho{}u{}h)}{dz}=
\frac{\hat{h}P}{A_{c}}(T_{w}-T)
$$

A expressão acima já consitui um modelo para o reator pistão, mas sua forma não é facilmente tratável analiticamente. Empregando a propriedade multiplicativa da diferenciaÇão podemos expandir o lado esquedo da equação como

$$
\rho{}u{}\frac{dh}{dz}+h\frac{d(\rho{}u)}{dz}=
\frac{\hat{h}P}{A_{c}}(T_{w}-T)
$$

O segundo termo acima é nulo em razão da conservação da matéria, como discutimos anteriormente. Da definição diferencial de entalpia $dh=c_{p}dT$ chegamos a formulação do modelo na temperatura como dado no título dessa seção.

$$
\rho{}u{}c_{p}A_{c}\frac{dT}{dz}=
\hat{h}P(T_{w}-T)
$$

Vamos agora empregar esse modelo para o cálculo da distribuição axial de temperatura ao longo do reator. No que se segue assume-se um reator tubular de seção circular de raio $R$ e todos os parâmetros do modelo são constantes.

### Integração analítica

Esse problema permite uma solução analítica simples que desenvolvemos de maneira um pouco abrupta no que se segue. Separando os termos em $T$ (variável dependente) e $z$ (variável independente) e integrando sobre os limites adequados obtemos

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

É trivial verificar com $T(z=0)=T_{0}$ que $\mathcal{C}_{1}=0$ o que conduz à solução analítica:

$$
T=T_{w}-(T_{w}-T_{0})\exp\left(-\frac{\hat{h}P}{\rho{}u{}c_{p}A_{c}}z\right)
$$

### Método dos volumes finitos

#finite-volume-method

Quando integrando apenas um reator, o método de integração numérica da equação é geralmente a escolha mais simples. No entanto, em situações nas quais desejamos integrar trocas entre diferentes reatores aquela abordagem pode se tornar proibitiva. Uma dificuldade que aparece é a necessidade de solução iterativa até convergência dados os fluxos pelas paredes do reator, o que demandaria um código extremamente complexo para se gerir em integração direta. Outro caso são trocadores de calor que podem ser representados por conjuntos de reatores em contra-corrente, um exemplo que vamos tratar mais tarde nesta série. Nestes casos podemos ganhar em simplicidade e tempo de cálculo empregando métodos que *linearizam* o problema para então resolvê-lo por uma simples *álgebra linear*.

Na temática de fenômenos de transporte, o método provavelmente mais frequentemente utilizado é o dos volumes finitos (em inglês abreviado FVM). Note que em uma dimensão com coeficientes constantes pode-se mostrar que o método é equivalente à diferenças finitas (FDM), o que é nosso caso neste problema. No entanto vamos insistir na tipologia empregada com FVM para manter a consistência textual nos casos em que o problema não pode ser reduzido à um simples FDM.

No que se segue vamos usar uma malha igualmente espaçada de maneira que nossas coordenadas de solução estão em $z\in\{0,\delta,2\delta,\dots,N\delta\}$ e as interfaces das células encontram-se nos pontos intermediários. Isso dito, a primeira e última célula do sistema são *meias células*, o que chamaremos de *condição limite imersa*, contrariamente à uma condição ao limite com uma célula fantasma na qual o primeiro ponto da solução estaria em $z=\delta/2$. Trataremos esse caso em outra ocasião.

O problema de transporte por advecção em um reator pistão é essencialmente *upwind*, o que indica que a solução em uma célula $E$ *a leste* de uma célula $P$ depende exclusivamente da solução em $P$. Veremos o impacto disto na forma matricial trivial que obteremos na sequência. Para a sua construção, começamos pela integração do problema entre $P$ e $E$, da qual se segue a separação de variáveis

$$
\int_{T_P}^{T_E}\rho{}u{}c_{p}A_{c}dT=
\int_{0}^{\delta}\hat{h}{P}(T_{s}-T^{\star})dz
$$

Observe que introduzimos a variável $T^{\star}$ no lado direito da equação e não sob a integral em $dT$. Essa escolha se fez porque ainda não precisamos definir qual a temperatura mais representativa deve-se usar para o cálculo do fluxo térmico. Logo vamos interpretá-la como uma constante que pode ser movida para fora da integral

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

No método dos volumes finitos consideramos que a solução é constante através de uma célula. Essa hipótese é a base para construção de um modelo para o parâmetro $T^{\star}$ na presente EDO. Isso não deve ser confundido com os esquemas de interpolação que encontramos em equações diferenciais parciais.

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

A dependência de $E$ somente em $P$ faz com que tenhamos uma matriz diagonal inferior, aonde os $-A^{-}$ são os coeficientes de $T_{P}$ na formulação algébrica anterior. A condição inicial modifica o primeiro elemento do vetor constante à direita da igualdade.

## Formulação na entalpia

Em diversos casos a forma expressa na temperatura não é conveniente. Esse geralmente é o caso quando se inclui transformações de fase no sistema. Nessas situações a solução não suporta integração direta e devemos recorrer a um método iterativo baseado na entalpia. Isso se dá pela adição de uma etapa suplementar da solução de equações não lineares para se encontrar a temperatura à qual a entalpia corresponde para se poder avaliar as trocas térmicas.

Para se efetuar a integração partimos do modelo derivado anteriormente numa etapa antes da simplificação final para solução na temperatura e agrupamos os parâmetros livres em $a$

$$
\frac{dh}{dz}=\frac{\hat{h}P}{\rho{}u{}A_{c}}(T_{s}-T^{\star})=a(T_{s}-T^{\star})
$$

É interessante observar que toda a discussão precedente acerca de porque não integrar sobre $T^{\star}$ perde seu sentido aqui: a temperatura é claramente um parâmetro.

$$
\int_{h_P}^{h_N}dh=a^{\prime}\int_{0}^{\delta}(T_{s}-T^{\star})dz
$$

Seguindo um procedimento de integração similar ao aplicado na formulação usando a temperatura chegamos a equação do gradiente fazendo $a=a^{\prime}\delta$

$$
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

### Solução em volumes finitos

#finite-volume-method 

Como as temperaturas usadas no lado direito da equação não são conhecidas inicialmente, o problema tem um caráter iterativo intrínseco. Inicializamos o lado direito da equação para em seguida resolver o problema na entalpia, que deve ser invertida (equações não lineares) para se atualizar as temperaturas. Isso se repete até que a solução entre duas iterações consecutivas atinja um *critério de convergência*.

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

## To-do

- Abordagem do modelo apresentado em ([[@Bird2001]]) 10.5.
- Nusselt variável segundo ([[@Bird2001]]) Tab. 14.2.