# Drafts

## LAMMPS

- Do exercises
- create a diffusion cell (one side initialized to a different type of atoms)

## Julia para cientistas

1. Lacos E Condicionais
1. Funcoes E Despacho
1. Pacotes E Ecossistema
1. Avaliando Performance
1. Algebra Linear
1. Expressoes Regulares
1. Execucao Concorrente
1. Trabalhando Com Arquivos
1. Bibliotecas Graficas
1. Graficos Para Publicacoes
1. Tipos De Dados E Estruturas
1. Metaprogramacao E Macros
1. Interoperacao Com C
1. Equações diferenciais ordinárias
1. Equações diferenciais parciais
1. Redes neuronais clássicas
1. Aprendizado com suporte físico
1. Análise quantitativa de imagens
1. Criando seus próprios pacotes

## Basilisk

### Planned studies

- Learning steps
	- [x] [Base tutorial](http://basilisk.fr/Tutorial)
	- [ ] [Review of main examples](http://basilisk.fr/src/examples/README)
	- [ ] [Review of extra examples (1)](http://basilisk.fr/sandbox/Antoonvh/README)
	- [ ] [Review of extra examples (2)](http://basilisk.fr/sandbox/M1EMN/README)
	- [ ] [Review of main tests](http://basilisk.fr/src/test/README)
	- [ ] [Review of built-it solvers](http://basilisk.fr/src/README)
	- [ ] [Dimensional analysis tutorial](http://basilisk.fr/Tutorial.dimensions)
	- [ ] [Basilisk C](http://basilisk.fr/Basilisk%20C)
	- [ ] [Past papers](http://basilisk.fr/Bibliography)

- Concluding projects
	- [ ] Convection equation ([samples](http://basilisk.fr/sandbox/M1EMN/README))
	- [ ] Diffusion equation ([samples](http://basilisk.fr/sandbox/M1EMN/README))
	- [ ] Burgers equation
	- [ ] Cavity flow Navier-Stokes

- Advanced projects
	- [ ] Carbonitriding of low alloy steels
	- [ ] JMAK kinetics and heat transfer
	- [ ] Drag-out flow in plate coating
	- [ ] Graf's acetylene decomposition flow
	- [ ] Rising bubble in fluid

- Things to check
	- [ ] Running simulations in parallel
	- [ ] Evaporation and combustion in sandbox
	- [ ] Examples with [granular flows](http://basilisk.fr/sandbox/M1EMN/README#examples-of-granular-flows) and [silos](http://basilisk.fr/sandbox/M1EMN/Exemples/granular_sandglass.c)
	- [ ] Rising bubble with granular flow

### Teaching plan

#### Week 1

- **In-class:** Fundamentals of scientific computing (history, basics of hardware, number representations, numerical solvers, parallel computing, etc.)
- **Tutorial:** Basics of Linux command line, VIM text editor, programming in C (with mini-projects), and Basilisk C.

## Using ElmerGUI

## Creating a case

- It is counter-intuitive, but to load a mesh in GUI one goes to `File > Open`, which can load several formats. Here we are using only `UNV` meshes generated by `gmsh`.

- Activate heat equation for all bodies in system and rename it to `Conduction`.

- Add two materials (`Portland`  and `Refractory`) and configure properties are needed.
	- Under `General` provide density and heat capacity
	- Under `Heat Equation` set heat conductivity

- Create an initial condition and set temperature to 298.15 K for all bodies.

- Create boundary conditions:
	- `Heat Source`at boundary 8 and set a Dirichlet condition for temperature of 813.15 K
	- `Symmetry` at boundaries 6/7 and set heat flux to 0 W (no gradient).
	- `Soil` at boundaries 1/2 and set a Dirichlet condition for temperature of 298.15 K.
	- `Environment` at boundary 3 and provide an HTC of 10 W/m/K and temperature of 298.15 K.

- Go to `Model > Setup` and check it defaults to steady state simulation.

- Inspect `Model > Summary...` before generating SIF file.
 
- Generate SIF with `Sif > Generate`.

- Now simulation is ready to `Run > Start solver`, inspect logs after finish.

- Before serious postprocessing, inspect solution with `Run > Start ElmerVTK`