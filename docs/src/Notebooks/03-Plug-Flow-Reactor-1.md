# Reator pistão - introdução

Este é o primeiro notebook de uma série abordando reatores do tipo *pistão* (*plug-flow*) no qual os efeitos advectivos são preponderantes sobre o comportamento difusivo, seja de calor, massa, ou espécies. O estudo e modelagem desse tipo de reator apresentar diversos interesses para a pesquisa fundamental e na indústria. Muitos reatores tubulares de síntese laboratorial de materiais apresentam aproximadamente um comportamento como tal e processos nas mais diversas indústrias podem ser aproximados por um ou uma rede de reatores pistão e reatores agitados interconectados.

Começaremos por um caso simples considerando um fluido incompressível e ao longo da série aumentaremos progressivamente a complexidade dos modelos. Os notebooks nessa série vão utilizar uma estratégia focada nos resultados, o que indica que o código será na maior parte do tempo ocultado e o estudante interessado deverá executar o notebook por si mesmo para estudar as implementações.

Nesta *Parte 1* vamos estuda a formulação na temperatura da equação de conservação de energia.

```julia
@info "Importando ferramentas..."

using CairoMakie
using DelimitedFiles
using DifferentialEquations: solve
using ModelingToolkit
using PlutoUI
using Printf
using SparseArrays
```

No que se segue vamos implementar a forma mais simples de um reator pistão. Para este primeiro estudo o foco será dado apenas na solução da equação da energia. As etapas globais implementadas aqui seguem o livro de [Kee *et al.* (2017)](https://www.wiley.com/en-ie/Chemically+Reacting+Flow%3A+Theory%2C+Modeling%2C+and+Simulation%2C+2nd+Edition-p-9781119184874), seção 9.2.

## Etapas preliminares

Da forma simplificada como tratado, o problema oferece uma solução analítica análoga à [lei do resfriamento de Newton](https://pt.wikipedia.org/wiki/Lei_do_resfriamento_de_Newton), o que é útil para a verificação do problema. Antes de partir a derivação do modelo, os cálculos do número de Nusselt para avaliação do coeficiente de transferência de calor são providos no que se segue com expressões de Gnielinski e Dittus-Boelter discutidas [aqui](https://en.wikipedia.org/wiki/Nusselt_number).

```julia

```
