# DualSPHysics

## Installation

A compressed package with binaries for both Linux and Windows (in the same file) can be retrieved [here](https://dual.sphysics.org/downloads/) while the source code is available on [GitHub](https://github.com/DualSPHysics/DualSPHysics).

- Start with extracting the compressed file to a directory of choice.
- There is no need to add the software to the path (batch scripts managed).

The following video provides a discussion of the above steps.

![@video](https://www.youtube.com/embed/_sL1iQUJfs8?si=LauFxw71VxstQ3qf)

## Documentation

Other than the `docs/` directory under the extracted folder tree, there is a [wiki](https://github.com/DualSPHysics/DualSPHysics/wiki) where the updated version of the documentation is maintained. There is little to no documentation of XML input format, what is reverse-engineered below.

The root of a simulation settings file is the `<case>` block, which by its turn is composed of `<casedef>` and `<execution>`. 

### `<casedef>`

It is used mainly for declaration of constants under `<constantsdef>` and `<geometry>`.

### `<execution>`

Under this block one may declare `<parameters>` related to solution controls declared through `<parameter>` entries, especially choice of algorithms, numerical parameters for tuning integration, and results related settings. It also provides the `<simulationdomain>`, which describes the bounding box of the system (generally left to defaults). 

#### `<parameter>`

The syntax of  `<parameter>` entries is as follows:

```xml
<parameter key="paramName" value="someValue" comment="Description" />
<parameter key="Rho" value="1000.0" comment="A density" units_comment="kg/m^3" />
```

## Guidelines

### Pressure probes

*See case `main/01_DamBreak` for details*. Due to the use of the dynamic boundaries, probes used for  measuring quantities should not be placed at the exact position of boundary particles. The forces exerted by the boundary particles create a small gap between them and fluid particles (1.5 times h); as a result, probes placed inside the gap will have a reduced fluid particle population and will produce either an incorrect or no result. To avoid this issue, it is proposed that probes are placed at a distance $1.5 h$ from the boundary positions.
