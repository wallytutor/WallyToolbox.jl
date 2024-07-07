# DryTransport

```@meta
CurrentModule = DryTransport
DocTestSetup  = quote
    using DryTransport
end
EditURL = "https://github.com/wallytutor/WallyToolbox.jl/blob/main/docs/src/DryTransport/index.md"
```

## Dimensionless groups

When dealing with reactor models, it is always useful to be able to quickly compute approximate dimensionless numbers for the studied case. In what follows we provide a brief description of these quantities. Definitions might vary according to the author or field of application and here we follow mostly  ([[@Bird2001]]).

### Groups by definition

The [Nusselt](https://en.wikipedia.org/wiki/Nusselt_number) number provides the ratio of convective to conductive heat transfer at a boundary in a fluid, defined as $\mathrm{Nu}=\frac{hL}{k}$. Often in buoyancy-driven flow analysis it is correlated as $\mathrm{Nu}=a\mathrm{Ra}^b$. A Nusselt number of value one represents heat transfer by pure conduction. Increasing this number implies a laminar conductive-dominant flow and then a convective dominant turbulent flow.

```@docs
DryTransport.nusselt
```

[Prandtl](https://en.wikipedia.org/wiki/Prandtl_number) represents the ratio of momentum diffusivity to thermal diffusivity $\mathrm{Pr}=\frac{\nu}{\alpha}$. High $\mathrm{Pr}$ indicates that momentum transfer is more effective than heat transfer (oils), while low values (liquid metals) indicate thermal boundary layer is more important than viscous one.

*Ludwig Prandtl (1875-1953) (pronounced "Prahn-t'), who taught in Hannover and Gottingen and later served as the Director of the Kaiser Wilhelm Institute for Fluid Dynamics, was one of the people who shaped the future of his field at the beginning of the twentieth century; he made contributions to turbulent flow and heat transfer, but his development of the boundary-layer equations was his crowning achievement* ([[@Bird2001]]). The dimensionless quantity appear under two forms of interest for the analysis of reactors: its thermal and its chemical versions. In thermal version, this number compares the kinematic viscosity $\nu$ to the thermal diffusivity $\alpha$, which is replaced by species diffusivity in its chemical version, which is more often referred to as Schmidt number. *Ernst Heinrich Wilhelm Schmidt (1892-1975), who taught at the universities in Gdansk, Braunschweig, and Munich (where he was the successor to Nusselt)* ([[@Bird2001]])_. The ratio $\frac{\nu}{\alpha}$ indicates the relative ease of momentum and energy or species transport in flow systems. This dimensionless ratio in thermal form is given by

$$
\mathrm{Pr} = \frac{\nu}{\alpha} = \frac{C_{p} \mu}{k}
$$

If transport properties for a gas are not available, thermal Prandtl number can be estimated at low pressure and non-polar molecules mixtures with help of Eucken formula as

  
$$
\mathrm{Pr} = \frac{C_{p}}{C_{p} + \frac{5}{4}R}
$$

```@docs
DryTransport.prandtl
```

[Reynolds](https://en.wikipedia.org/wiki/Reynolds_number) *dimensionless group is named for Osborne Reynolds (1842-1912), professor of engineering at the University of Manchester. He studied the laminar-turbulent transition, turbulent heat transfer, and theory of lubrication* ([[@Bird2001]]). In general we denote Reynolds number by $\mathrm{Re}$ and it is used to delineate flow regimes. For circular tubes it is defined as:

$$

\mathrm{Re} = \frac{\rho \langle v_{z} \rangle D}{\mu}

$$

where $\langle{}v_{z}\rangle$ is the average flow velocity in axial direction and $D$ is the tube diameter. For values up 2100 the flow is assumed laminar if steady state is established and density is constant. For more, see ([[@Bird2001]]), Chapter 2.

```@docs
DryTransport.reynolds
```

### Groups by application

```@docs
DryTransport.ConstantPrandtl
```

```@docs
DryTransport.ReynoldsPipeFlow
DryTransport.NusseltGnielinski
DryTransport.NusseltDittusBoelter
```

## Heat transfer coefficients

```@docs
DryTransport.HtcPipeFlow
DryTransport.htc
```
