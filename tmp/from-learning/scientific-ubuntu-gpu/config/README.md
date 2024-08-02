# Jupyterhub service

By default, this Jupyterhub instance provides you with Python, R, Lua, SageMath, and Octave kernels. Julia language and Haskell are available and respective kernels can be installed by users on their own profiles. For installing Julia kernel simply run the following command:

```bash
julia -e 'using Pkg; Pkg.add("IJulia"); Pkg.build("IJulia")'
```

In the case of Haskell check instructions provided [here](https://github.com/gibiansky/IHaskell). You might also be interested in Rust, which can be installed with the following:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
source ${HOME}/.cargo/env
rustup default nightly
```

In that case you will be prompted to add this line to `.bashrc`:

```bash
source ${HOME}/.cargo/env
```

It is also a good practice to add this line to `.bashrc`:

```bash
export PATH="${HOME}/.local/bin:${PATH}"
```
---

## Simulation packages

Some simulation packages are installed but not readily put into the path. For these you need to source the package to make it available. If you wish to use Cantera consider adding the following to your `.bashrc` file:

```bash
source /opt/cantera/bin/setup_cantera
```

If you need OpenCalphad, the following lines need to be added:

```bash
export OCHOME=/opt/opencalphad
export PATH="${OCHOME}:${PATH}"
```

Since OpenFOAM may come in various flavors (currently we have v9 and v2112), sourcing directly from `.bashrc` is not the recommended solution. Instead you can choose to source:

```bash
source /usr/lib/openfoam/openfoam2112/etc/bashrc
```

for OpenFOAM v2112 (ESI) or

```bash
source /opt/openfoam9/etc/bashrc
```

for OpenFOAM v9 (ORG), which is expected to be sourced from a terminal or notebook when working with `cfdtoolbox` package. In addition to these CFD packages, we also have SU2 from Stanford University. This package can be made available with the following:

```bash
source /opt/SU2/bashrc
```

Currently you need to `export OMPI_MCA_btl_vader_single_copy_mechanism=none` to be able to use MPI.

---

## Other simulation tools

The following tools are also available in the service:

- [FEniCSx](https://fenicsproject.org/) for finite element method.
- [LAMMPS](https://www.lammps.org/) for molecular dynamics.
- [ESPResSo](https://espressomd.org/wordpress/) for molecular dynamics and LBM.

---

## GPU usage

Currently the server is restricted to 4GB of VRAM for Cuda. The available memory at any time can be checked with `nvtop`. Soon this quota will be largelly increased.
