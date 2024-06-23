# Elmer Multiphysics

Elmer is a multiphysics finite element method (FEM) solver mainly developed by CSC and maintained at [GitHub](https://github.com/ElmerCSC/elmerfem). Several resources can be found in is [official webpage](https://www.csc.fi/web/elmer) and in the [community portal](https://www.elmerfem.org/blog/) and in the [forum](https://www.elmerfem.org/forum/index.php). There is also an [YouTube channel](https://www.youtube.com/@elmerfem) with several tutorials and illustration of the package capabilities.

The goal of this page is not to supersede the [documentation](https://www.csc.fi/web/elmer/documentation), but to make it (partially) available as a webpage where search and navigation become more intuitive. *Notice that this will be fed according to my personal projects and learning, so any contribution to accelerate the process is welcome.* Here you find a *user-guide-style* page while more details are provided in the selected notes of [Elmer Documentation](Elmer-Documentation.md).

---
## Read me first

### Quick answers

- [Is Elmer the adequate tool for my projects?](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/ElmerOverview.pdf) In this document you find a short introduction to what Elmer can do and the main executables. 

- [How do I start learning Elmer?](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/GetStartedElmer.pdf) Simply put, Elmer does not require basic users to master all the fundamentals of FEM, so following the *getting started* guide seems a good starting point. There you learn how to install, configure, and run the software.

- [Where do I get the binaries of Elmer?](https://www.nic.funet.fi/pub/sci/physics/elmer/) If willing to run in Windows, the previous link provides the compiled binaries; there are also instructions for installing directly in Ubuntu as well as all the documentation and other test and sample cases.

- [I feel alone, where do I find other users?](https://www.elmerfem.org/forum/) The forum seems to be moderately active, so you can go there to chat with other users and developers if you are not in a hurry.

### Limitations and issues

- Currently the GUI is not able to import SIF files generated manually because it stores its state in a XML file; to be able to re-run cases from the GUI users need to create the equivalent case (eventually using the free text fields) in the GUI itself before regenerating a SIF file. Notice that this will overwrite the SIF file, so keep in mind to backup the file in another directory; that is especially required for highly customized cases.

### Ongoing work

- Development of a [VS Code syntax highlight extension](https://github.com/wallytutor/WallyToolbox.jl/tree/main/tools/vscode/extensions/wally-sif) with help of data provided in [SOLVER.KEYWORDS](https://github.com/ElmerCSC/elmerfem/blob/devel/fem/src/SOLVER.KEYWORDS).

### Retrieving materials

Because there are plenty of interesting materials in Elmer public directory, it is worth downloading it all and selecting what to keep later. In a Linux terminal one could run the following command. If you also want to retrieve the animations, binaries, and virtual machines, consider removing and/or modifying the `-X` options.

```bash
#!/usr/bin/env bash

URL="https://www.nic.funet.fi/pub/sci/physics/elmer/"

wget -r -l 20 --no-parent           \
    -X /pub/sci/physics/elmer/anim/ \
    -X /pub/sci/physics/elmer/bin/  \
    -R "index.html*"                \
    ${URL}
```

---

## Elmer Fundamentals

### Preprocessing steps

- Other than the native `ElmerGrid`, several other software can be used for conceiving a geometry and mesh generation workflow. Users are encouraged to use external tools such as [gmsh](https://gmsh.info/) or [Salome](https://www.salome-platform.org/) to generate computational meshes, built-in support in Elmer bein limited to very simple geometries only. For complex geometries [FreeCAD](https://www.freecad.org/) is a standout alternative. For more consider reading [Geometry and Preprocessing](Geometry-and-Preprocessing.md).

- Not all `gmsh` standard mesh formats are supported, but only version 2 (as for OpenFOAM); that said, users are encouraged to export mesh in UNV format to avoid compatibility issues, and also because both proposed tools support it. You can control the element orders in command line using option `-order <N>`; gmsh operates this way so that the same script can generate any supported element type.

- For importing meshes one uses `ElmerGrid <input-format> <output-format>`, where the format arguments are documented in the [manual](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/ElmerGridManual.pdf) sections 1.3 and 1.4. The UNV input is given by number 8 while standard `ElmerSolver` output by number 2, so that the conversion command would start with `ElmerGrid 8 2 <other-arguments...>`. Always verify the number of nodes remain untouched after conversion - or if it changed when using option `-merge <dist>`, merging nodes that are closer than the user-defined `<dist>`.

- Remember to use `Coherence;`  with OpenCASCADE factory in gmsh scripts to automatically strip internal faces; that might not be enough for complex cases, see below. **Note:** I tried doing so and unless `Physical Surfaces` naming the external boundaries are provided every interface is dumped and imported by Elmer; maybe I misunderstood the use of command!

- Because faces are not named in Elmer, *i.e.* no matter what `Physical Surface` names you provide in gmsh, even for the advanced user working from command line it might be interesting to use the interactive zone grouping capabilities of `ElmerGUI`. That might even become a *requirement* as geometric complexity grows.

| Software | Notes                                                                                                              |
| -------- | ------------------------------------------------------------------------------------------------------------------ |
| FreeCAD  | Geometry only for now, probably the best in the list; good parametric modeling support.                            |
| Salome   | Can export UNV (8) meshes readable by Elmer. An extension to call Elmer directly from Salome is under development. |
| gmsh     | Can export MSH2 (14) and UNV (8) formats readable by Elmer.                                                        |
| netgen   | Is able to write native Elmer linear meshes; can be used as a plug-in.                                             |
| tetgen   | Can be used as a plug-in.                                                                                          |

### Using Elmer

- Newcomers might be interested in `ElmerGUI`; although very intuitive, the interface is quite limited and for complex programs running from command line is the preferred mode.

- Most users will finally end setting up an workflow employing both to `ElmerSolver` (to run the simulations) and `ElmerGrid` (to prepare the grid and setup parallelization).

- There is also `ViewFactors` which might be useful in special cases involving radiation and other executables but they are not mentioned here because they fall in the legacy code family.

- Users must be aware that Elmer has no default unit system; one must take care that units are coherent across the different models and materials.

- Support to mathematical operations in SIF through MATC, which has its own [syntax and documentation](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/MATCManual.pdf). It can be used, *e.g.* for computing temperature dependent properties, what can be helpful for simple expressions (instead of writing Fortran 90 code for extensions).

### Parallel computing

- Before running in parallel a working case running in serial is required; using `ElmerGUI` this can be enabled in `Run > Parallel settings...`. Notice that after running postprocessing of `.pvtu` needs to be done in ParaView directly.

- To partition the mesh from command line one needs to run `ElmerGrid 2 2 <mesh-name> -partdual -metiskway <N>`, which will convert `<mesh-name>` from Elmer mesh format (2) into itself (thus the `2 2` in the command) and dump the resulting mesh in `partitions.<N>`, with `<N>` being the number of physical cores to run the simulation.

- Parallel cases can be run with `mpiexec -n <N> ElmerSolver_mpi`. Notice that under Linux the MPI runner is called `mpirun` instead of `mpiexec`.

### Tips and ideas

- Use `Coordinate Mapping` to rotate meshes with oriented particles
- Scaling of a single direction can be done with `Coordinate Scaling`
- Time step can be changed with a list of elements in `Timestep Intervals`, *e.g.*

```Fortran
! Run 10 time-steps of 0.1 s, then 100 with 1.0 s.
Timestep Intervals(2) = 10 100
Timestep Sizes(2) = 0.1 1.0
```

- Take care with `Linear System Abort Not Converged = True` for physical consistency; generally continuing a simulation after a failed step is worthless unless one is pseudo-stepping towards a difficult (highly nonlinear) steady-state.

### Material properties

Material properties can be specified as:

- Constant: just the default numeric input in SIF files

- Tabulated linearly or using a cubic spline, *e.g.*

```Fortran
! Linear interpolation
Viscosity = Variable Temperature
  Real
	298.15 1.0
	! ... more data here
	373.15 2.0
End

! Cubic spline interpolation
Viscosity = Variable Temperature
  Real cubic
	298.15 1.0
	315.15 1.1
	345.15 1.5
	! ... more data here
	373.15 2.0
End
```

- Arrays: for representing anisotropic bodies, *e.g.*

```Fortran
Heat Conductivity(3,3) = 1 0 0\
                         0 1 0\
                         0 0 2
```

- Using MATC as explained [here](Elmer-Documentation.md). Notice that sourcing files in MATC is the recommended way to get reusable code; coding MATC in SIF files requires to escape all lines and quickly becomes messy.

- User-defined functions (UDF) can also be provided in Fortran; notice that even when MATC can be used, this may lead to a speed-up of calculations with the inconvenient of needing more code. So for cases that are intended to be reused, it is important to consider writing proper extensions in Fortran. The following example illustrates a temperature dependent thermal conductivity function which is evaluated by Elmer at all nodes. In most cases a simple `USE DefUtils` is enough to get the required Elmer API to write the extension.

```Fortran
FUNCTION conductivity(model, n, time) RESULT(k)
    !**************************************************************
    ! Load Elmer library.
    !**************************************************************
    
    USE DefUtils
    IMPLICIT None

    !**************************************************************
    ! Function interface.
    !**************************************************************
    
    TYPE(Model_t) :: model
    INTEGER       :: n
    REAL(KIND=dp) :: time, k

    !**************************************************************
    ! Function internals.
    !**************************************************************
    
    TYPE(Variable_t), POINTER :: varptr
    REAL(KIND=dp) :: T
    INTEGER :: idx

    !**************************************************************
    ! Actual implementation
    !**************************************************************

    ! Retrieve pointer to the temperature variable.
    varptr => VariableGet(model%Variables, 'Temperature')

    ! Access index of current node.
    idx = varptr%Perm(n)

    ! Retrieve nodal temperature.
    T = varptr%Values(idx)

    ! Compute heat conductivity from NodalTemperature, k=k(T)
    k = 2.0 - T * (2.5e-03 - 1.0e-06 * T)
END FUNCTION conductivity
```

In order to compile the above assume it is written to `properties.f90` file; then one can call `elmerf90 properties.f90 –o properties` to generate the required shared library that is loaded in runtime by Elmer. Below we illustrate the use of `Procedure` to attach this library to a given material; first one provides the name of the shared library then the name of the function. A single library can in fact contain several functionalities.

```C
Material 1
  Name = "Solid"
  Heat Conductivity = Variable Time
    Procedure "properties" "conductivity"
  Heat Capacity = 1000
  Density = 2500
End
```

### Postprocessing

For postprocessing the recommended way is by using external tools as [ParaView](https://www.paraview.org/) and [PyVista](https://docs.pyvista.org/version/stable/), both handling well the VTK format of outputs. Nonetheless there are a some in-solver processing utilities that are worth knowing, especially in what concerns extracting and filtering data from certain regions, creating new fields, and computing fluxes.

#### Creating a new scalar

The keyword set of materials is actually not fixed; one can, for instance, create composition field in different units with MATC, as illustrated below (case [here](https://github.com/wallytutor/WallyToolbox.jl/tree/main/apps/Elmer/diffusion_solids/carburizing_slycke_gui)):

```Fortran
MoleFraction = Variable Concentration
  Real MATC "carbonmolefraction(tx)"
```

Then in solver `SaveMaterials`, this new name `MoleFraction` can be used as a variable:

```Fortran
Solver 1
  Equation = SaveMaterials
  Parameter 1 = Concentration Diffusivity
  Parameter 2 = MoleFraction
  Procedure = "SaveData" "SaveMaterials"
  Exec Solver = After Timestep
End
```

Another situation that can be frequently found is unit conversion for temperature. It was chosen to implement it in [this case](https://github.com/wallytutor/WallyToolbox.jl/tree/main/apps/Elmer/conduction_refractory/transient_parallel) because it is multi-material; that is a reminder that in such cases the new variable needs to be created for all materials (as this is a tweak, since the temperature is not a material property, but a global field). If forgotten in one material, an error will show up in ParaView telling you that the field is not available in some regions.

---
## Elmer documentation

### Solver Input Files (SIF)

Once you get serious with Elmer it is a natural evolution to prefer to work with SIF files instead of the GUI most of the time. This is also true in a majority of scientific computing software. The documentation of SIF is spread over the whole documentation of Elmer and this page tries to consolidate the most of it. For the beginner, this [video](https://www.youtube.com/watch?v=iXVEqKTq5TE) is a good starting point, this page being more of a reference manual.

Because syntax highlighting is important for productivity, I am working in a minimalistic extension for VS Code. Its partial development can be found [here](https://github.com/wallytutor/WallyToolbox.jl/tree/main/helpers/syntax-highlighters/sif). After cloning the repository, simply copy the `sif/` directory under `%USERPROFILE%/.vscode/extensions`  on in the equivalent directory documented [here](https://code.visualstudio.com/docs/editor/extension-marketplace#_where-are-extensions-installed).

### MATC

Elmer provides a few extension methods. For complex models you might be prompted to use directly Fortran 90. For simpler things, such as providing temperature dependent thermophysical properties, it has its own parser for use in SIF, the metalanguage MATC. Expressions provided in MATC can be evaluated when file is read or during simulation execution.

Because it is quite concise, I summarized the whole of MATC syntax and functions in this page. For the official documentation please refer to [this document](https://www.nic.funet.fi/pub/sci/physics/elmer/doc/MATCManual.pdf).

#### Declaring variables

Variables in MATC can be matrices and strings; nonetheless, both are stored as double precision arrays so creating large arrays of strings can represent a waste of memory. For some weird reason I could not yet figure out, MATC language can be quite counterintuitive.

Let's start by creating a variable, say `x` below; attribution, such a in Python, creates the variable. It was stated that everything is a matrix or string; since `x` is not a string, it is actually a $1\times{}1$ matrix and in this case we can omit the indexing when allocating its memory.

```C
x = 1
```

So far nothing weird; when declaring a string as `k` below we are actually creating a $1\times{}5$ row matrix, what is not unusual in many programming languages (except for being double precision here). Furthermore, we use the typical double-quotes notation for strings.

```C
k = "hello"
```

Matrix indexing is zero-based, as in C or Python. Matrix slicing is done as in many scripting languages, such as Python, Julia, Octave, ..., and we can reverse the order of the first *six* elements of an array `y` as follows: 

```C
y(0, 0:5) = y(0, 5:0)
```

Notice above the fact that matrix slicing is *last-inclusive*, as in Julia, meaning that all elements from index zero to five *inclusive* are included in the slice. Weirdness starts when you do something like

```C
z(0:9) = 142857
```

which according to the documentation will produce an array `1 4 2 8 5 7 1 4 2 8`; I could not verify this behavior yet. Additionally, the following produces another unexpected result:

```C
z(9, 9) = 1
```

If matrix `z` does not exist, this results in a $10\times{}10$ matrix with all zeros except the explicitly declared element. The size of variables are dynamic, so in the above if `z` already existed but wa smaller, it would be padded with zeros instead.

Finally, logical indexing is also allowed:

```C
x(x < 0.05) = 0.05
```

#### Control structures

MATC provides conditionals and loops as control structures. Below we have the `if-else` statement, which can be declared inline of using a C-style declaration using braces.

```C
if ( expr ) expr; else expr;

if ( expr )
{
    expr;
    ...
    expr;
} else {
    expr;
    ...
    expr;
}
```

Loops can be declared using both `for` or `while`. There is no mechanism of generating values within a `for` loop and one must provide a vector of indexes for repetition. *In the official documentation there is no reference to a `continue` or `break` statement and I could not verify their existence yet*.

```C
for( i=vector ) expr;

for( i=vector )
{
    expr;
    ...
    expr;
}

while( expr ) expr;

while( expr )
{
    expr;
    ...
    expr;
}
```

#### Operators

Assume the following definitions:

- `a`, `b` and `c` ordinary matrices  
- `l`, `t` and `r` logical matrices 
- `s`, `n` and `m` scalars 

|                                      |                                                                                                                                                                               |
| ------------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `b = a'`                             | is transpose of matrix a.                                                                                                                                                     |
| `b = @a`                             | evaluate content of a string variable a as a MATC statement.                                                                                                                  |
| `t = ~l`                             | elementwise logical not of  if x is not zero.                                                                                                                                 |
| `b = a ^ s`                          | if a is a square matrix and s is integral, a matrix power is computed, otherwise an elementwise power.                                                                        |
| `c = a * b`                          | if a and b are compatible for matrix product, that is computed, otherwise if they are of the same size or at least one of them is scalar, an elementwise product is computed. |
| `c = a # b`                          | elementwise multiplication of a and b.                                                                                                                                        |
| `c = a / b`                          | is fraction of a and b computed elementwise.                                                                                                                                  |
| `c = a + b`                          | is sum of matrices a and b computed elementwise.                                                                                                                              |
| `c = a - b`                          | is difference of matrices a and b computed elementwise.                                                                                                                       |
| `l = a == b`                         | equality of matrices a and b elementwise.                                                                                                                                     |
| `l = a <> b`                         | inequality of matrices a and b elementwise.                                                                                                                                   |
| `l = a < b`                          | true if a is less than b computed elementwise.                                                                                                                                |
| `l = a > b`                          | true if a is greater than b computed elementwise.                                                                                                                             |
| `l = a <= b`                         | true if a is less than or equal to b computed elementwise.                                                                                                                    |
| `l = a >= b`                         | true if a is greater than or equal to b computed elementwise.                                                                                                                 |
| `a = n : m`                          | return a vector of values starting from n and ending to m by increment of (plus-minus) one.                                                                                   |
| `r = l & t`                          | elementwise logical and of a and b.                                                                                                                                           |
| `l = a \| b`                         | elementwise logical or of a and b.                                                                                                                                            |
| `c = a ? b`                          | reduction: set values of a where b is zero to zero.                                                                                                                           |
| `b = n m % a`                        | resize a to matrix of size n by m.                                                                                                                                            |
| `b = a`                              | assigning a to b.                                                                                                                                                             |

#### Function definitions

The syntax of the function definition is similar to that of Julia and is given below. The function body is enclosed by braces. Instead of using a `return` statement, the resulting value is attributed to a variable named after the function with a leading underscore. Notice the `!` denoting comments in the description of the function.

```Fortran
function name(arg1, arg2, ...)
!
! Optional function description (seen with help("name"))
!
import var1, var2
export var3, var4
{
    expr;
     ...
    expr;

    _name = value
}
```

Functions have their own list of variables. Global variables are not seen in this function unless imported by `import` or given as arguments. Local variables can be made global by the `export` statement. 

Functions, if returning matrices, behave in many ways as variables do. So if you have defined function `mult` as follows 

```Fortran
function mult(a, b)
{
   _mult = a * b;
}
```

You can get element (3,5) of the `a` times `b` matrix with `mult(x,y)[3,5]` or the diagonal values of the same matrix by `diag(mult(x, y))`.

#### Built-in functions

##### C-style math

The following listing provides a series of mathematical functions which follow a their meaning in C. The only exceptions are `ln` denoting the natural logarithm and `log` used here for base 10 logarithms.

```C
r = sin(x)

r = cos(x)

r = tan(x)

r = asin(x)

r = acos(x)

r = atan(x)

r = sinh(x)

r = cosh(x)

r = tanh(x)

r = exp(x)

r = ln(x)

r = log(x)

r = sqrt(x)

r = ceil(x)

r = floor(x)

r = abs(x)

r = pow(x,y) 
```

##### General utilities

|                                      |                                                                                                         |
| ------------------------------------ | :------------------------------------------------------------------------------------------------------ |
| `funcdel(name)`                      | Delete given function definition from parser.                                                           |
| `funclist(name)`                     | Give header of the function given by name.                                                              |
| `env(name)`                          | Get value of environment variable of the operating system.                                              |
| `exists(name)`                       | Return true (non-zero) if variable by given name exists otherwise return false (=0).                    |
| `source(name)`                       | Execute commands from file given name.                                                                  |
| `format(precision)`                  | Set number of digits used in printing values in MATC.                                                   |
| `r = eval(str)`                      | Evaluate content of string str. Another form of this command is `@str`.                                 |
| `who`                                | Give list of currently defined variables.                                                               |
| `help` or `help("symbol")`           | First form of the command gives list of available commands. Second form gives help on specific routine. |

##### String and I/O functions

|                                      |                                                                                                                                                                                                                                                                                       |
| ------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `str = sprintf(fmt[,vec])`     | Return a string formatted using `fmt` and values from `vec`. A call to corresponding C-language function is made.                                                                                                                                                                     |
| `vec = sscanf(str,fmt)`        | Return values from `str` using format `fmt`. A call to corresponding C-language function is made.                                                                                                                                                                                     |
| `str = fread(fp,n)`            | Read `n` bytes from file given by `fp`. File pointer fp should have been obtained from a call to `fopen` or `freopen`, or be the standard input file stdin. Data is returned as function value.                                                                                       |
| `vec = fscanf(fp,fmt)`         | Read file `fp` as given in format. Format fmt is equal to C-language format. File pointer `fp` should have been obtained from a call to `fopen` or `freopen`, or be the standard input.                                                                                               |
| `str = fgets(fp)`              | Read next line from fp. File pointer fp should have been obtained from a call to fopen or freopen or be the standard input.                                                                                                                                                           |
| `n = fwrite(fp,buf,n)`         | Write n bytes from buf to file fp. File pointer fp should have been obtained from a call to fopen or freopen or be the standard output (stdout) or standard error (stderr). Return value is number of bytes actually written. Note that one matrix element reserves 8 bytes of space. |
| `n = fprintf(fp,fmt[, vec])`   | Write formatted string to file fp. File pointer fp should have been obtained from a call to fopen or freopen or be the standard output (stdout) or standard error (stderr). The format fmt is equal to C-language format.                                                             |
| `fputs(fp,str)`                | Write string str to file fp. File pointer fp should have been obtained from a call to fopen or freopen or be the standard input (stdin).                                                                                                                                              |
| `fp = fopen(name,mode)`        | Reopen file given previous file pointer, name and access mode. The most usual modes are `"r"` for reading and `"w"` for writing. Return value fp is used in functions reading and writing the file.                                                                                   |
| `fp = freopen(fp,name,mode)`   | Reopen file given previous file pointer, name and access mode. The most usual modes are `"r"` for reading and `"w"` for writing. Return value fp is used in functions reading and writing the file.                                                                                   |
| `fclose(fp) `                  | Close file previously opened with fopen or freopen.                                                                                                                                                                                                                                   |
| `save(name, a[,ascii_flag])`   | Close file previously opened with `fopen` or `freopen`.                                                                                                                                                                                                                               |
| `r = load(name)`               | Load matrix from a file given name and in format used by `save` command.                                                                                                                                                                                                              |

##### Numerical utilities

|                                      |                                                                                                                                                                                                                        |
| --------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `r = min(matrix)`           | Return value is a vector containing smallest element in columns of given matrix. r = min(min(matrix)) gives smallest element of the matrix.                                                                            |
| `r = max(matrix)`           | Return value is a vector containing largest element in columns of given matrix. `r = max(max(matrix))` gives largest element of the matrix.                                                                            |
| `r = sum(matrix)`           | Return vector is column sums of given matrix. `r = sum(sum(matrix))` gives the total sum of elements of the matrix.                                                                                                    |
| `r = zeros(n,m)`            | Return n by m matrix with elements initialized to zero.                                                                                                                                                                |
| `r = ones(n,m)`             | Return n by m matrix with elements initialized to one.                                                                                                                                                                 |
| `r = rand(n,m)`             | Return n by m matrix with elements initialized with random numbers from zero to one.                                                                                                                                   |
| `r = diag(a)`               | Given matrix return diagonal entries as a vector. Given vector return matrix with diagonal elements from vector. `r = diag(diag(a))` gives matrix with diagonal elements from matrix `a`, otherwise elements are zero. |
| `r = vector(start,end,inc)` | Return vector of values going from start to end by inc.                                                                                                                                                                |
| `r = size(matrix)`          | Return size of given matrix.                                                                                                                                                                                           |
| `r = resize(matrix,n,m)`    | Make a matrix to look as a `n` by `m` matrix. This is the same as `r = n m % matrix`.                                                                                                                                  |
| `r = where(a)`              | Return a row vector giving linear index to `a` where `a` is not zero.                                                                                                                                                  |
| `r = matcvt(matrix, type)`  | Makes a type conversion from MATC matrix double precision array to given type, which can be one of the following: `"int"`, `"char"` or `"float"`.                                                                      |
| `r = cvtmat(special, type)` | Makes a type conversion from given type to MATC matrix. Type can be one of the following: `"int"`, `"char"` or `"float"`.                                                                                              |

##### Linear algebra

|                                      |                                                                                                                                                                      |
| ------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `r = trace(matrix)`                  | Return value is the sum of matrix diagonal elements.                                                                                                                 |
| `r = det(matrix)`                    | Return value is determinant of given square matrix.                                                                                                                  |
| `r = inv(matrix)`                    | Invert given square matrix. Computed also by operator $^{-1}$                                                                                                        |
| `r = tril(x)`                        | Return the lower triangle of the matrix x.                                                                                                                           |
| `r = triu(x)`                        | Return the upper triangle of the matrix x.                                                                                                                           |
| `r = eig(matrix)`                    | Return eigenvalues of given square matrix. The expression `r(n,0)` is real part of the n:th eigenvalue, `r(n,1)` is the imaginary part respectively.                 |
| `r = jacob(a,b,eps)`                 | Solve symmetric positive definite eigenvalue problem by Jacob iteration. Return values are the eigenvalues. Also a variable eigv is created containing eigenvectors. |
| `r = lud(matrix)`                    | Return value is LUD decomposition of given matrix.                                                                                                                   |
| `r = hesse(matrix)`                  | Return the upper hessenberg form of given matrix.                                                                                                                    |
| `r = eye(n)`                         | Return n by n identity matrix.                                                                                                                                       |

#### Usage

Although the language is pretty fast for most simple uses, it is much slower than Fortran extensions, so use with case when scalability is needed. Another point is overuse of MATC; do not use it with simple numerical expressions, *e.g.* `OneThird = Real $1.0/3.0` is much faster than its MATC counterpart `OneThird = Real MATC "1.0/3.0"`.

##### Direct expression coding

One thing that in my opinion lacks in the documentation are examples of use in conjunction with SIF. For instance, for setting the thermal conductivity of a material as temperature-dependent one could use the following snippet and modify the string to match the desired expression. An example of its usage is provided in [this case](https://github.com/wallytutor/WallyToolbox.jl/blob/main/apps/Elmer/conduction_refractory/transient_parallel/case.sif).

```C
  Heat Conductivity = Variable Temperature
    Real MATC "1.0 - tx * (2.5E-03 - 1.2E-06 * tx)"
```

##### Sourcing functions from user modules

Models can become too complex to code in a single line. Hopefully MATC provides functions which can be declared in external modules. I avoid coding MATC directly in SIF because their syntax is different and that can quickly lead to unmaintainable code. An example of such external sourcing is provided in [this case](https://github.com/wallytutor/WallyToolbox.jl/tree/main/apps/Elmer/diffusion_solids/carburizing_slycke). You need to remember to call `source("module")` in `Simulation` section of SIF so that the functions can be used elsewhere.  The call of a function become something as

```C
  Concentration Diffusivity = Variable Concentration
    Real MATC "diffusivity(tx)"
```

if independent variable is concentration or for time

```C
  Mass Transfer Coefficient = Variable Time
    Real MATC "masstransfercoef(tx)"
```

You can even use multiple variables, *e.g.*

```C
  Mass Transfer Coefficient = Variable Time, Temperature
    Real MATC "masstransfercoef(tx(0), tx(1))"
```

 PS: *I managed to use a single `source` in SIF, although the documentation does not state that many sources are forbidden; for some reason multiple sources work when sourcing from a file.*
	
For more complex cases such as [this one](https://github.com/wallytutor/WallyToolbox.jl/tree/main/apps/Elmer/diffusion_solids/carburizing_slycke_gui) it is worth writing actual MATC function modules; since there is no syntax highlighter available for MATC in VS Code, the `.ini` extension seems to provide better readability to the code. The problem was split in two parts: the [models](https://github.com/wallytutor/WallyToolbox.jl/blob/main/apps/Elmer/diffusion_solids/carburizing_slycke_gui/models.ini) which take care of sourcing the [conditions](https://github.com/wallytutor/WallyToolbox.jl/blob/main/apps/Elmer/diffusion_solids/carburizing_slycke_gui/conditions.ini), so that basic users could only edit the latter and run their variant calculations with no coding skills. Notice that the symbols that are used in [SIF](https://github.com/wallytutor/WallyToolbox.jl/blob/main/apps/Elmer/diffusion_solids/carburizing_slycke_gui/case.sif) are exported from [this line](https://github.com/wallytutor/WallyToolbox.jl/blob/main/apps/Elmer/diffusion_solids/carburizing_slycke_gui/models.ini#L72) instead of being set as global variables.

### User-defined functions

TODO
