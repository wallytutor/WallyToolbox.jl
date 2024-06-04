# LAMMPS

[Large-scale Atomic/Molecular Massively Parallel Simulator](https://www.lammps.org/#gsc.tab=0) or simply LAMMPS is a popular molecular dynamics software. It has probably the largest community and is highly mature, reasons why I have chosen this software to learn molecular dynamics at first. Later on I intend learning [Molly.jl](https://juliamolsim.github.io/Molly.jl/stable/) and maybe 

In what follows I will be mostly guided by the [LAMPPS tutorials](https://lammpstutorials.github.io/) by [Simon Gravelle](https://scholar.google.com/citations?user=9fD2JlYAAAAJ&hl=en) in what concerns the contents, with some touches of automation by myself. Interesting materials are also inspired in what is provided by the [MEJK Course](https://mejk.github.io/moldy/intro.html)

The official documentation of LAMMPS can be found [here](https://docs.lammps.org/Manual.html).

## Resources

- [MAICoS](https://maicos.readthedocs.io/en/main/get-started/maicos.html)
- [MDAnalysis](https://www.mdanalysis.org/)
- [PyVista](https://docs.pyvista.org/version/stable/)
- [VMD](https://www.ks.uiuc.edu/Research/vmd/)

## Workflow of a simulation

### System initialization

Comprises all basic definitions, such as domain boundaries specification, types of atoms, potentials, etc. This step is common to most simulations and it is worth writing parts of it as shared scripts in larger projects.

The basic building blocks of a simulation include the definition of `units`, `dimension` and `boundary`; these are followed by a number of styles, which are responsible by defining the types of particles, how they interact between themselves, bond types, …, etc. The following snippet provides a minimal setup for a system consisting of atoms only, the simplest `atom_style`.

```c
units           lj
dimension       3
boundary        p p p

atom_style      atomic
pair_style      lj/cut 2.5
```

For simple diatomic molecules, one needs to add a `bond_style`:

```c
...
atom_style      molecular
bond_style      harmonic
...
```

And when going towards multiatomic molecules,  an `angle_style` is also needed:

```c
...
atom_style      molecular
bond_style      harmonic
angle_style     harmonic
...
```

For the creation of simulation domain one needs to declare one or more0 [`region`](https://docs.lammps.org/region.html) entities; it is possible then to perform logical operations to select intersections, …, etc. The simplest of the regions is a trivial block, with dimensions `xyz` given as a sequence of pairs of minimum and maximum as follows.

```c
#<command>      <name>         <type> <x min max> <y min max>  <z min max>
region          simulation_box block     -20 20      -20 20       -20 20
create_box      3 the_box
```

In the above cell we also used `create_box` with argument `3`, meaning we intend to have 3 atom types in the simulation domain. Next we can create a cylinder of radius 10 along z-axis:

```c
region          cylinder_in  cylinder z 0 0 10 INF INF side in
region          cylinder_out cylinder z 0 0 10 INF INF side out
```

To be able to use an `INF` (infinite) dimension along a direction on must have created the block `the_box` ahead of the cylinder. Fortunately the error messages of LAMMPS are pretty expressive and one can quickly find a fix. Try commenting out the `create_box` in the script and check it. You can check the [region command](https://docs.lammps.org/region.html) for more.

*Note*: here we will use a more complex version of `create_box` because this tutorial simulation aims at considering molecular species. The simplest version above is valid for atoms only.

```c
create_box      3 simulation_box &
    bond/types             1     &
    angle/types            1     &
    extra/bond/per/atom    1     &
    extra/angle/per/atom   2     &
    extra/special/per/atom 5
```

Molecule creation syntax is provided [here](https://docs.lammps.org/molecule.html).

### Energy minimization

When atoms are placed randomly in a domain there is a high probability of *explosion* of interaction forces due to overlap; a minimization step is generally required to search a *sane* starting point before time integration.

### Integration of the equations of motion

With all interaction forces and a reasonable initial condition defined during minimization, time integration can be performed. This is generally done through the [Verlet algorithm](https://en.wikipedia.org/wiki/Verlet_integration), although there are [other methods](https://docs.lammps.org/run_style.html) available in LAMMPS. The key factor here is finding a suitable time step; as a rule-of-thumb, it is ideally about 5% of the time between collisions.

### Trajectory visualization

Prior to integration one defines the data to be stored with the simulation. A common tool (freeware but not open source) in this field is [VMD](https://www.ks.uiuc.edu/Research/vmd/), for which a tutorial is provided [here](https://lammpstutorials.github.io/sphinx/build/html/tutorials/vmd/vmd-tutorial.html#vmd-label).

## LAMMPS usage

- A simulation script is simply parsed and run with `lmp -in inputs.lammps`.

- LAMMPS supports some regular expressions, *i.e.* you can set all masses to unity by calling `mass * 1.0`, where the `*` evaluates to all atom types already created.

- Omitted pairwise interaction parameters are by default computed by geometric averaging; Lorentz-Berthelot arithmetic rule is more common, though there is no rigorous argument for justifying any of them and they should be used with care in the absence of better data.

## Key concepts

- Langevin thermostat, see ([[@Schneider1978a]]).
## Tutorials

### Lennard-Jones fluid

In this tutorial the following concepts are dealt with:

- Basic setup of a simulation with atomic types only.

- Concept of box and regions for system definition and random initialization of atoms inside region volumes, *e.g.* using cylinders to define where each type of atom must be.

- Tracking of thermodynamics during minimization run and finding a suitable initial condition though minimization before proceeding with molecular dynamics simulation properly said.

The Lennard-Jones potential is defined as

$$
E(r) = 4\epsilon_{ij}\left[
	\left(\frac{\sigma_{ij}}{R}\right)^{12}
	-\left(\frac{\sigma_{ij}}{R}\right)^{6}
\right]
$$

This potential can be implemented in an efficient way by introducing $r=(\sigma_{ij}R^{-1})^6$:

```julia; @example notebook
ljpotential(r, ϵ) = 4ϵ * r * (r - 1)

nothing; # hide
```

The evaluation of this is can be managed by a type as provided below; notice the use of a function object operator for accessing the internals of `PairInterLJ`:

```julia; @example notebook
struct PairInterLJ
    ϵ::Float64
    σ::Float64
end

(self::PairInterLJ)(R::Float64) = ljpotential((self.σ / R)^6, self.ϵ)

nothing; # hide
```

In the simulations we have used default parameters for interactions between different types of atoms; that implies geometric mean of both interaction potential $\epsilon_{ij}$ and distance parameter $\sigma_{ij}$. An alternative would be a Lorentz-Berthelot arithmetic mean (for distance parameter only). To compare these we overload the structure constructor:

```julia; @example notebook
function PairInterLJ(p::PairInterLJ, q::PairInterLJ; method = :arithmetic)
    method ∈ [:arithmetic, :geometric] || throw("Unknown method $(method)")
    
    σ = (method == :arithmetic) ? (p.σ + q.σ) / 2.0 : sqrt(p.σ * q.σ)
    
    return PairInterLJ(sqrt(p.ϵ * q.ϵ), σ)
end

nothing; # hide
```

Using the case data we can compute the following interaction potentials:

```julia; @example notebook
pair11 = PairInterLJ(1.0, 1.0)
pair22 = PairInterLJ(0.5, 3.0)

pair12_g = PairInterLJ(pair11, pair22; method = :geometric)
pair12_a = PairInterLJ(pair11, pair22; method = :arithmetic)

nothing; # hide
```

```julia; @example notebook
pair12_g
```

```julia; @example notebook
pair12_a
```

Visualization is straightforward with Makie:

```julia; @example notebook
using CairoMakie

R = LinRange(0.9, 6, 500)

fig = with_theme() do	
    f = Figure()
    ax = Axis(f[1, 1]; xlabel = L"R", ylabel = L"E(R)")
    lines!(ax, R, pair11.(R);   label = L"E_{11}",   color = :red)
    lines!(ax, R, pair22.(R);   label = L"E_{22}",   color = :blue)
    lines!(ax, R, pair12_g.(R); label = L"E_{12,g}", color = :black)
    lines!(ax, R, pair12_a.(R); label = L"E_{12,a}", color = :green)
    ax.xticks = 1.0:1.0:6.0
    xlims!(ax, 0.95, 6.0)
    ylims!(ax, -1.02, 1.0)
    axislegend(ax; position = :rt)
    f
end

fig
```

For proper representation of results, following the VDM tutorial one can further:

- Learn to represent atoms with proper scaling using `VWD` representation and after manipulation dump the state in the same directory as the trajectories file for ease of reloading; in this case it is simply a matter of `File > Load Visualization State...`.

- Generate animation using the included *Internal Tachyon* (unless you have a local Tachyon installation) library and process with FFmpeg with command `ffmpeg -framerate 30 -i "results.%05d.bmp" -vf "select=not(mod(n\,3)),scale=372x360" animation.gif`. For selecting every `n-th` frame use [this approach](https://superuser.com/a/1274696/1979854).
