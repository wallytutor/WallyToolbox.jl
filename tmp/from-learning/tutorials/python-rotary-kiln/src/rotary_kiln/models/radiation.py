# -*- coding: utf-8 -*-

# Import external modules.
import numpy as np

# Own imports.
from ..data import data_dir
from ..types import PathLike
from ..types import Tensor
from .machine_learning import NeuralModel
    


class RadcalWrapper(NeuralModel):
    """ Wrapper over neural network to predict gas properties. 
    
    Parameters
    ----------
    fmodel: PathLike
        Path to Keras sequential model to be loaded. 
    fscale: PathLike
        Path to model scaler to be loaded.
    """
    def __init__(self, fmodel: PathLike, fscale: PathLike):
        if fmodel is None or fscale is None:
            fmodel = data_dir / "radcal.h5"
            fscale = data_dir / "radcal.yaml"

        super().__init__(fmodel, fscale)

    def get_arguments(self,
            T_w: Tensor, 
            T_g: Tensor, 
            p_h2o: Tensor, 
            p_co2: Tensor, 
            L: Tensor
        ) -> Tensor:
        """ Stack model input parameters in required format.
        
        Parameters
        ----------
        T_w: Tensor
            Wall temperature [K].
        T_g: Tensor
            Gas temperature [K].
        p_h2o: Tensor
            Partial pressure of water [atm].
        p_co2: Tensor
            Partial pressure of carbon dioxide [atm].
        L: Tensor
            Reference optical length [m].

        Returns
        -------
        Tensor
            Parameters stacked in a tensor in model-compatible format.
        """
        pg = p_h2o + p_co2
        return np.vstack((T_w, T_g, pg*L, p_co2/pg))
