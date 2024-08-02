# FuMEs Backend Service

This package provide the single chamber continuous annealing furnace atmosphere model with optimization Furnace Modeling of Exchanges - FuMEs built upon [CasADi](https://web.casadi.org/) framework and using optimization from [Ipopt](https://coin-or.github.io/Ipopt/). It is intended to be used as the basis for simulating furnace atmospheres from scripts, graphical user interfaces or web applications. For such, it provides both a Python `ctypes` and a `.NET Core` interface. Sample applications are provided under [samples](samples/) directory.

## Build

**Note:** before starting the build, carefully read instructions till the end. For external dependencies it is preferred to run the steps manually since unexpected changes might break the build. Make sure CasADi and Ipopt are in the right path before running local solution build.

### External dependencies

1. Clone [CasADi](https://github.com/casadi/casadi) sources from GitHub inside [external](external/) directory with `git clone https://github.com/casadi/casadi.git`.
1. Enter CasADi sources and checkout to version 3.5.4 with `git checkout 3.5.4` to have the compatible version. Please notice that version 3.5.5 (the latest release as of this notice) is producing allocation errors in the main application library.
1. Download version 3.14.2 of Ipopt binary distribution from [GitHub](https://github.com/coin-or/Ipopt/releases/download/releases%2F3.14.2/Ipopt-3.14.2-win64-msvs2019-md.zip).
1. Extract Ipopt zip file inside [external](external/).
1. Open Visual Studio, select `Continue without code...` and go to menu `File > Open > CMake...`, navigate to cloned CasADi sources and select `CMakeLists.txt`. It will take a few moments to finish loading CMake configuration.
1. Replace `CMakeSettings.json` in CasADi directory by [external/CMakeSettings.json](external/CMakeSettings.json), which assumes the correct version of Ipopt has been downloaded and placed in the same directory.
1. Go to menu `Project > Rescan Solution`.
1. Now menu `Generate Cache for casadi` will be enabled to run.
1. To compile libraries go to `Build > Build All`.
1. Once compilation is finished run `Build > Install casadi` and a directory `external/install` should contain the release files.
1. Clone [SymbSol](https://gogs.sprtmonitor.com/walter/symbsol-headers) inside [external](external/) directory with `git clone https://gogs.sprtmonitor.com/walter/symbsol-headers.git`. This is a headers only library and the main solution is already including it to the includes path if cloned in the right place. **Note**: once FuMEs backend is stable this library will be hard-integrated to the solution since it is a free time personal development that cannot be ensured to remain available online.

### FuMEs Modules

**Note:** Before building select Release-x64 configuration. The project was not tested under x86 and is not guaranteed to work.

The project is conceived for Windows and requires Visual Studio 16 (2019) and `C++ 2017` for the core library. Except for CasADi and Ipopt described above, C++ core does not rely on any other library. A wrapper is provided in .NET C# implemented as `netstandard2.0` and sample applications on `netcoreapp2.1`. For running the sample it is also necessary to have the NuGet of `ScottPlot 4.1.16`. If all the steps above were followed strictly and external libraries are in the correct locations, is should be enough to go to menu `Build > Build Solution` or press `F7` to get the solution compiled. From the solution navigation sidebar it is possible to select the sample case to run.

## Use cases

**Note:** it is up to the end user to properly validate the input structure ranges. At the current state, the main library and its wrappers are solely mathematical formulations and calls to the optimizers and assume everything was validated before arriving there. For units of inputs, everything is assumed to be in industrial standard and until documentation is released it is possible to check conversions explicitly in static function `ConvertUnitsEntering` of [fumes-core/fumes.cpp](src/fumes-core/fumes.cpp). Output units are in SI units for now and some outputs are still missing (constants, dew point set-point).

For calling the library from C# please consider the sample [samples/fumes-wrapper-call](samples/fumes-wrapper-call/Program.cs). The API was reduced to a single call to `FuMEsWrapper.FuMEsModel` constructor with the structure `FuMEsWrapper.FuMEsInputs`. Results can be accessed from `Outputs` attribute of  `FuMEsWrapper.FuMEsModel` which is of type `FuMEsWrapper.FuMEsOutputs`. Names of attributes in `FuMEsWrapper.FuMEsInputs` are mostly self-explanatory, while those in `FuMEsWrapper.FuMEsOutputs` conserve for now similarity with problem mathematical formulation. Documentation for both is coming soon.

Pure C++ API is [samples/fumes-core-call](samples/fumes-core-call/Program.cpp). Inputs and outputs structures are provided in [fumes-core/fumes.hpp](src/fumes-core/fumes.hpp).

## To-Do's

- [x] Create `fumes-core-call` in C++ in samples.
- [x] Pass arguments from C# to C++ for feeding model.
- [x] Write C++ tests to call from C# tests for input validation.
- [x] Add static (local) unit conversion function in fumes.cpp.
- [x] Convert time-dependent parameters into heaviside composition.
- [x] Write a generic RK4 stepping function for integration of step.
- [x] Create symbolic problem stepper as in Galsa 2 Python version.
- [x] Write problem multiple-shooting symbolic integration.
- [x] Write optimization manager and results structure.
- [x] Add plotting functionalities to C# library.
- [ ] Add conversion of units back to industrial values in outputs.
- [ ] Add JSON input parsing to C# library.
- [ ] Add content to `fumes-core-tests`.
- [ ] Add physical boiler model to core library.
- [ ] Review all TODO's in code.
