# -*- coding: utf-8 -*-

# Postpone runtime parsing of annotations.
from __future__ import annotations

# Import Python built-in modules.
from typing import Any
import abc

# Own imports.
from .types import NumberOrVector
from .types import Vector
from .types import Matrix


class BaseHtcModel(abc.ABC):
    """ A generic class implement kiln heat transfer coefficients. """
    @abc.abstractmethod
    def update(self,
            rho: NumberOrVector,
            mu: NumberOrVector,
            u: NumberOrVector,
            w: float
        ) -> None:
        """ Update model common internal parameters. """
        pass

    @abc.abstractmethod
    def h_gb(self, kg: NumberOrVector, **kwargs) -> NumberOrVector:
        """ Gas-bed heat transfer coefficient. """
        pass

    @abc.abstractmethod
    def h_gw(self, kg: NumberOrVector, **kwargs) -> NumberOrVector:
        """ Gas-wall heat transfer coefficient. """
        pass

    @abc.abstractmethod
    def h_wb(self, kb: NumberOrVector, **kwargs) -> NumberOrVector:
        """ Wall-bed heat transfer coefficient. """
        pass


class BaseODESystem(abc.ABC):
    """ A generic model implementing an ODE system. """
    def __init__(self) -> None:
        super().__init__()
        # To be initialized in derived constructor.
        self._initial_value = None
        self._n_vars = None

        # Keep track of parent kiln object.
        self._kiln = None

        # Must be set in derived `register_section_getter`.
        # Retrieve coordinate-dependent geometric properties.
        self._get_section = None

    @abc.abstractmethod
    def __call__(self, z: float, state: Vector, **kwargs) -> Vector:
        """ Evaluate model ODE system right-hand side."""
        pass

    @abc.abstractmethod
    def register_section_getter(self, kiln: Any) -> None:
        """ Creates a function to retrieve section properties. """
        self._kiln = kiln

    @property
    def n_vars(self) -> int:
        """ Access to number of variables for integrator. """
        return self._n_vars

    @property
    def initial_value(self) -> Vector:
        """ Access to initial conditions for integrator. """
        return self._initial_value


class BaseThermoFreeboard(BaseODESystem):
    """ Base class for freeboard phase models.
    
    For developers: notice that the methods of this class assume
    an API from Cantera kinetics library, as implied by `_sarr`
    property (expected to be of type `SolutionArray`). This can
    be overriden by wrapping user-defined thermophysics in this
    same format, what is considered interesting from an coding
    standpoint because allow for easy change of physics backend.
    """
    def __init__(self) -> None:
        super().__init__()
        # Must be set in derived `register_section_getter`.
        # Memory for tabulation of gas properties.
        self._sarr = None

    def get_gas_properties(self,
            T: Vector,
            Y: Matrix
        ) -> tuple[Vector, Vector, Vector]:
        """ Use gas object to provide model parameters.
        
        Parameters
        ----------
        T: Vector
            Vector of freeboard temperatures [K].
        Y: Matrix
            Matrix of freeboard mass fractions [-]

        Returns
        -------
        tuple[Vector, Vector, Vector]
            Specific weights [kg/m³], viscosities [Pa.s] and thermal
            conductivities [W/(m.K)] vectors at provided points.
        """
        self._sarr.TPY = T, None, Y
        return (self._sarr.density,
                self._sarr.viscosity,
                self._sarr.thermal_conductivity)

    def get_mole_fractions(self, Y: Matrix) -> Matrix:
        """ Convert mass fractions to mole fractions. """
        self._sarr.TPY = None, None, Y
        return self._sarr.X

    def species_index(self, name: str) -> int:
        """ Get species index from kinetic mechanism. """
        return self._sarr.species_index(name)


class BaseThermoBed(BaseODESystem):
    """ Base class for bed phase models. """
    def __init__(self) -> None:
        super().__init__()

    @abc.abstractmethod
    def thermal_conductivity(self, T: NumberOrVector) -> NumberOrVector:
        """ Access to bed thermal conductivity [W/(m.K)]. """
        pass

    @abc.abstractmethod
    def thermal_diffusivity(self, T: NumberOrVector) -> NumberOrVector:
        """ Access to bed thermal_diffusivity [m²/s]. """
        pass

    @property
    @abc.abstractmethod
    def specific_mass(self) -> float:
        """ Access to bed specific weight [kg/m³]. """
        pass

    @property
    @abc.abstractmethod
    def repose_angle(self) -> float:
        """ Access to bed repose angle [rad]. """
        pass
