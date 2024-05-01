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
    from pde import FieldCollection
    from pde import MemoryStorage
    from pde import PDEBase
    from pde import PlotTracker
    from pde import ScalarField
    import marimo as mo
    import numpy as np
    import pde
    return (
        FieldCollection,
        MemoryStorage,
        PDEBase,
        PlotTracker,
        ScalarField,
        mo,
        np,
        pde,
    )


@app.cell(hide_code=True)
def __():
    """ Ideal gas constant [J/(mol.K)]. """
    GAS_CONSTANT = 8.314_462_618_153_24
    return GAS_CONSTANT,


@app.cell(hide_code=True)
def __(GAS_CONSTANT, np):
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
    return KineticsJMAK,


@app.cell(hide_code=True)
def __(mo):
    mo.md(rf"For the present study we simplify the model to have $H=0$.")
    return


@app.cell(hide_code=True)
def __(KineticsJMAK):
    kin = KineticsJMAK(H = 0.0, n = 3.5, k = 1.0e-05, E = 1.0e+04)
    kin
    return kin,


@app.cell(hide_code=True)
def __(kin):
    kin(1000.0, 0.0)
    return


@app.cell
def __(KineticsJMAK, self):
    class Material:
        """ Sample material with temperature-dependent properties. """
        def __init__(self, kin: KineticsJMAK):
            self.kin = kin
            
        def density(u):
            """ Material density [kg/m³]. """
            return 2600.0
        
        def specific_heat(u):
            """ Material specific heat [J/(kg.K)]. """
            return 1100.0

        def thermal_conductivity(u):
            """ Material thermal conductivity [W/(m.K)]. """
            return 1.4 - u * (1.75e-03 - 1.43e-06 * u)

        def transformation_rate(u, b):
            """ Hypothetical phase transformation rate [1/s]. """
            return self.kin(u, b)
    return Material,


@app.cell
def __(Material, kin):
    mat = Material(kin)
    return mat,


@app.cell
def __(FieldCollection, PDEBase, T):
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
            b_t, q_t = self.mat(u, b)

            # Evaluate material properties.
            rho = self.mat.density(u)
            cp = self.mat.specific_heat(u)
            k = self.mat.thermal_conductivity(u)

            # Compute temperature derivatives.
            u_p = k * T.laplace(self.bc)
            u_t = (u_p + q_t) / (rho * cp)
            
            return FieldCollection([u_t, b_t])
    return NonlinearHeatConductionModel,


@app.cell
def __():
    return


if __name__ == "__main__":
    app.run()
