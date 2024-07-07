import marimo

__generated_with = "0.4.7"
app = marimo.App()


@app.cell(hide_code=True)
def __(mo):
    mo.md(
        r"""
        # Non-linear heat transfer with reaction

        ## To-do's

        - Move towards an enthalpy formulation for temperature-dependent specific heat
        - Check [this](https://py-pde.readthedocs.io/en/latest/examples_gallery/pde_heterogeneous_diffusion.html) example for implementing spacial dependencies.

        ## Reaction rate

        In [JMAK kinetics](https://royalsocietypublishing.org/doi/10.1098/rsif.2023.0242) the degree of progress of transformation is given as:

        \[
        X = 1 - \exp\left(-\beta^n\right)
        \]

        This sort of kinetics is valid only for constant heating rate; [Mittemeijer et al.](https://doi.org/10.1007/BF02628377) proposes a generalization of state $\beta$ in terms of a kinetic constant $k$ as:

        \[
        d{}\beta=k(T)d{}t\implies{}\beta=\int_{0}^{t}k(T)d{}t
        \]

        Assuming an Arrhenius rate constant $k$, and using the above expressions the time derivatives of reaction progress $\beta$ and heat release rate $\dot{q}$ can be shown to be:

        \[
        \begin{align*}
        \dot{\beta} &= k\exp\left(-\frac{E}{RT}\right)\\[12pt]
        \dot{q}     &= \dot{\beta}Hn\beta^{n-1}
        \exp\left(-\beta^n\right)
        \end{align*}
        \]

        In order to introduce not just temperature dependent, but also compound-dependent thermophysical properties, we follow (integrate) the evolution o $\beta$ along with the heat equation over the domain.
        """
    )
    return


@app.cell(hide_code=True)
def __():
    from matplotlib import pyplot as plt
    from pde import CylindricalSymGrid
    from pde import FieldCollection
    from pde import MemoryStorage
    from pde import PDEBase
    from pde import PlotTracker
    from pde import ScalarField
    import marimo as mo
    import numpy as np
    import pde
    return (
        CylindricalSymGrid,
        FieldCollection,
        MemoryStorage,
        PDEBase,
        PlotTracker,
        ScalarField,
        mo,
        np,
        pde,
        plt,
    )


@app.cell(hide_code=True)
def __(FieldCollection, PDEBase, np):
    """ Ideal gas constant [J/(mol.K)]. """
    GAS_CONSTANT = 8.314_462_618_153_24


    class KineticsJMAK:
        """ Johnson-Mehl-Avrami-Kolmogorov reaction kinetics.
        
        Parameters
        ----------
        H: float
            Reaction specific enthalpy [J/kg].
        n: float
            Exponential rate shape factor [-].
        k: float
            Reaction rate pre-exponential factor. [1/s].
        E: float
            Activation energy [J/(mol.K)].
        """
        def __init__(self, H: float, n: float, k: float, E: float):
            self.H, self.n, self.k, self.E = H, n, k, E
        
        def derivative(self, T):
            """ Time derivative of process state. """
            return self.k * np.exp(-self.E / (GAS_CONSTANT * T))
        
        def __repr__(self):
            """ String representation of object. """
            fmt = "<ReactionJMAK H={:.6e} n={:.6e} k={:.6e} E={:.6e} />"
            return fmt.format(self.H, self.n, self.k, self.E)

        def __call__(self, T, b):
            """ Evaluate process derivative and heat release. """
            b_t = self.derivative(T)
            q_t = b_t * self.H * self.n * pow(b, self.n-1)
            q_t *= np.exp(-pow(b, self.n))
            return np.array([b_t, q_t])


    class Material:
        """ Sample material with temperature-dependent properties. """
        def __init__(self, kin: KineticsJMAK):
            self.kin = kin

        @staticmethod
        def density(u):
            """ Material density [kg/m³]. """
            return 2600.0

        @staticmethod
        def specific_heat(u):
            """ Material specific heat [J/(kg.K)]. """
            return 1100.0

        @staticmethod
        def thermal_conductivity(u):
            """ Material thermal conductivity [W/(m.K)]. """
            return 1.4 - u * (1.75e-03 - 1.43e-06 * u)

        def transformation_rate(self, u, b):
            """ Hypothetical phase transformation rate [1/s]. """
            return self.kin(u, b)


    class NonlinearHeatConductionModel(PDEBase):
        """ Nonlinear heat conduction with reaction kinetics. """
        def __init__(self, bc, mat) -> None:
            super().__init__()
            self.bc = bc
            self.mat = mat

        def evolution_rate(self, state, t=0.0):
            """ PDE's of system dynamics. """
            # Unpack solution variables.
            u, b = state

            # Compute ROP and heat release rate.
            b_t, q_t = self.mat.transformation_rate(u, b)

            # Evaluate material properties.
            rho = self.mat.density(u)
            cp = self.mat.specific_heat(u)
            k = self.mat.thermal_conductivity(u)

            # Compute temperature derivatives.
            u_p = k * u.laplace(self.bc)
            u_t = (u_p + q_t) / (rho * cp)
            
            return FieldCollection([u_t, b_t])
    return (
        GAS_CONSTANT,
        KineticsJMAK,
        Material,
        NonlinearHeatConductionModel,
    )


@app.cell(hide_code=True)
def __(mo):
    mo.md(rf"For the present study we simplify the model to have $H=0$.")
    return


@app.cell(hide_code=True)
def __(KineticsJMAK, Material):
    kin = KineticsJMAK(H = 0.0, n = 3.5, k = 1.0e-05, E = 1.0e+04)
    mat = Material(kin)

    kin, kin(1000.0, 0.0)
    return kin, mat


@app.cell
def __(mo):
    density_r = mo.ui.slider(start=50, stop=1000, step=25, value=500)
    density_z = mo.ui.slider(start=50, stop=1000, step=25, value=500)
    s_u_0 = mo.ui.slider(start=20, stop=300, step=5, value=20)
    s_u_inf = mo.ui.slider(start=20, stop=2000, step=20, value=500)
    return density_r, density_z, s_u_0, s_u_inf


@app.cell
def __(density_r, density_z, mo, s_u_0, s_u_inf):
    mo.md(rf"""

    | | | |
    |---|---|---|
    | Mesh density over radius | 1/m | {density_r} |
    | Mesh density over height | 1/m | {density_z} |
    | Initial temperature      | °C  | {s_u_0} |
    | External temperature     | °C  | {s_u_inf} |
    """)
    return


@app.cell
def __(
    MemoryStorage,
    NonlinearHeatConductionModel,
    density_r,
    density_z,
    mat,
    s_u_0,
    s_u_inf,
):
    u_0 = s_u_0.value + 273.15
    u_inf = s_u_inf.value + 273.15

    h_inf = 1000.0

    t_stp = 1.0
    t_end = 600.0
    interval = 5*t_stp

    radius = 0.05
    height = 0.10

    bounds_z = (-height/2, height/2)

    nr = int(density_r.value * radius)
    nz = int(density_z.value * height)
    mem = MemoryStorage()

    h = h_inf / mat.thermal_conductivity(u_inf)

    bc = [{"type": "mixed", "value": h, "const": h * u_inf},
          {"type": "mixed", "value": h, "const": h * u_inf}]

    model = NonlinearHeatConductionModel(bc, mat)
    return (
        bc,
        bounds_z,
        h,
        h_inf,
        height,
        interval,
        mem,
        model,
        nr,
        nz,
        radius,
        t_end,
        t_stp,
        u_0,
        u_inf,
    )


@app.cell
def __(
    CylindricalSymGrid,
    FieldCollection,
    ScalarField,
    bounds_z,
    interval,
    mem,
    model,
    nr,
    nz,
    radius,
    t_end,
    t_stp,
    u_0,
):
    grid = CylindricalSymGrid(radius = radius, bounds_z = bounds_z,
                              shape = (nr, nz), periodic_z = False)

    u = ScalarField(grid, data=u_0,  label="u")
    b = ScalarField(grid, data=0.0,  label="b")

    state = FieldCollection([u, b])
    tracker = ["progress", mem.tracker(interval=interval)]

    sol = model.solve(state, t_range = (0.0, t_end), dt = t_stp,
                      tracker = tracker, solver = "explicit")
    return b, grid, sol, state, tracker, u


@app.cell
def __(mem, np, nr, nz, plt):
    def get_entry(field):
        u_avg = field["u"].data.mean()
        u_obs = field["u"].data[nr//2, nz//2]
        return u_avg, u_obs

    history = np.array(list(map(get_entry, mem)))

    t_mean = np.array(mem.times) / 60.0
    u_mean = history[:, 0] - 273.15
    u_root = history[:, 1] - 273.15

    fig, ax = plt.subplots(1, 1, figsize=(8, 6), facecolor="w")

    ax.plot(t_mean, u_mean, label="Mean")
    ax.plot(t_mean, u_root, label="Center")
    ax.grid(linestyle=":")
    ax.set_xlabel("Time [min]")
    ax.set_ylabel("Temperature [°C]")
    ax.legend()
    fig.tight_layout()

    fig
    return ax, fig, get_entry, history, t_mean, u_mean, u_root


@app.cell
def __():
    return


@app.cell
def __():
    return


if __name__ == "__main__":
    app.run()
