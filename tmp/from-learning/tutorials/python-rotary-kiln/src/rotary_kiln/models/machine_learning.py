# -*- coding: utf-8 -*-

# Import Python built-in modules.
from typing import Callable
import abc

# Import external modules.
from keras.models import load_model
import numpy as np
import yaml

# Own imports.
from ..types import PathLike
from ..types import Tensor


class NeuralModel(abc.ABC):
    """ Base class for neural network wrapper.
    
    Parameters
    ----------
    fmodel: PathLike
        Path to Keras sequential model to be loaded. 
    fscale: PathLike
        Path to model scaler to be loaded.
    """
    def __init__(self, fmodel: PathLike, fscale: PathLike) -> None:
        super().__init__()
        model = load_model(fmodel)
        self._scaler = load_standard_scaler(fscale)
        self._model = lambda X: model(self._scaler(X))

    def __call__(self, *args):
        """ Prepare arguments and return model evaluation """
        return self._model(self.get_arguments(*args).T).numpy().T

    @abc.abstractmethod
    def get_arguments(self, *args) -> Tensor:
        """ Interface for argument processing to be implemented. """
        pass

    @property
    def scaler(self):
        """ Provide access to model scaler. """
        return self._scaler
    

def load_standard_scaler(fname: PathLike) -> Callable[[Tensor], Tensor]:
    """ Load scaler data and return inputs transformer.
    
    Parameters
    ----------
    fname: PathLike
        Path to YAML file containing mean and variance parameters
        for data scaling. This file will be loaded as a dictionary
        expected to contain keywords `mean` and `var`.

    Returns
    -------
    Callable[[Tensor], Tensor]
        A standard scaler accepting the tensor to be transformed.

    Raises
    ------
    AttributeError
        If any of the required keywords is not found in YAML file.
    """
    with open(fname) as fp:
        scaler_data = yaml.safe_load(fp)
        
    if "mean" not in scaler_data or "var" not in scaler_data:
        raise AttributeError("Check required keywords in YAML file.")

    mean = np.array(scaler_data["mean"])
    std = np.array(scaler_data["var"])**(1/2)

    return lambda X: (X - mean) / std
