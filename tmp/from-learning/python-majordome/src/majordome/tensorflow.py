# -*- coding: utf-8 -*-
from typing import Optional
from matplotlib import pyplot as plt
from matplotlib.figure import Figure


def plot_history(
        data_history: dict[str, list[float]],
        metric: str,
        style: Optional[str] = "seaborn-white",
        gridstyle: Optional[str] = ":",
        figsize: Optional[tuple[float, float]] = (12, 6),
        loc : Optional[str] = "upper left"
    ) -> Figure:
    """ Plot trainning history data for Tensorflow.
    
    Parameters
    ----------
    data_history : dict[str, list[float]]
        Training and validation data history returned by Tensorflow.
    metric : str
        Name of metric function used for training.
    style : Optional[str] = "seaborn-white"
        Matplotlib plotting style for customizing figure.
    gridstyle : Optional[str] = ":"
        Grid style to apply in plots.
    figsize : Optional[tuple[float, float]] = (12, 6)
        Figure size provided to matplotlib.
    loc : Optional[str] = "upper left"
        Legend placement in subplots.

    Returns
    -------
    Figure
        Matplotlib figure for user display or save.
    """
    legend = ["Train", "Test"]

    plt.close("all")
    plt.style.use(style)
    fig = plt.figure(figsize=figsize)

    plt.subplot(121)
    plt.plot(data_history[metric])
    plt.plot(data_history[F"val_{metric}"])
    plt.title("Metric over epochs")
    plt.ylabel("Metric")
    plt.xlabel("Epoch")

    if gridstyle is not None:
        plt.grid(linestyle=gridstyle)

    plt.legend(legend, loc=loc)

    plt.subplot(122)
    plt.plot(data_history["loss"])
    plt.plot(data_history["val_loss"])
    plt.title("Loss over epochs")
    plt.ylabel("Loss")
    plt.xlabel("Epoch")

    if gridstyle is not None:
        plt.grid(linestyle=gridstyle)

    plt.legend(legend, loc=loc)

    fig.tight_layout()
    return fig


def plot_regression_quality(
        Y_real: list[float],
        Y_pred: list[float],
        Y_abse: list[float],
        style: Optional[str] = "seaborn-white",
        gridstyle: Optional[str] = ":",
        figsize: Optional[tuple[float, float]] = (12, 6),
        lims1: Optional[tuple[float, float]] = None,
        lims2: Optional[tuple[float, float]] = None,
        bins: Optional[int] = 20
    ) -> Figure:
    """ Confront regrssion predictions against expected values.
    
    Parameters
    ----------
    Y_real: list[float]
        Array of expected values.
    Y_pred: list[float]
        Array of predicted values.
    Y_abse: list[float]
        Array of absolute errors. Note: this is not computed
        internally to avoid manipulation of possible tensor data.
    style : Optional[str] = "seaborn-white"
        Matplotlib plotting style for customizing figure.
    gridstyle : Optional[str] = ":"
        Grid style to apply in plots.
    figsize : Optional[tuple[float, float]] = (12, 6)
        Figure size provided to matplotlib.
    lims1: Optional[tuple[float, float]] = None
        Limits of both axes in confrontation plot.
    lims2: Optional[tuple[float, float]] = None
        Limit of error axis in histogram plot.
    bins: Optional[int] = 20
        Number of bins to use in histogram.

    Returns
    -------
    Figure
        Matplotlib figure for user display or save.
    """
    plt.close("all")
    plt.style.use(style)
    fig = plt.figure(figsize=figsize)

    plt.subplot(121)
    plt.plot(Y_real, Y_pred, "o", alpha=0.6)
    plt.plot(Y_real, Y_real, "k:")
    plt.title("Evaluation of model accuracy")
    plt.xlabel("Expected value")
    plt.ylabel("Computed value")
    plt.xlim(lims1)
    plt.ylim(lims1)
    plt.axis("equal")

    if gridstyle is not None:
        plt.grid(linestyle=gridstyle)

    plt.subplot(122)
    plt.hist(Y_abse, bins=bins, density=True)
    plt.title("Histogram of absolute error")
    plt.xlabel("Expected value")
    plt.ylabel("Computed value")
    plt.xlim(lims2)

    if gridstyle is not None:
        plt.grid(linestyle=gridstyle)

    fig.tight_layout()
    return fig
