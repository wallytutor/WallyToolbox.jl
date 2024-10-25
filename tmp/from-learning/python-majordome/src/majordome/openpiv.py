# -*- coding: utf-8 -*-
from dataclasses import dataclass
from pathlib import Path
from typing import Optional
from imageio.core.util import Array
from matplotlib.figure import Figure
from openpiv.tools import imread
from openpiv.tools import negative
from openpiv.tools import save as txtsave
from openpiv.tools import transform_coordinates
from openpiv.pyprocess import extended_search_area_piv
from openpiv.pyprocess import get_coordinates
from openpiv.validation import sig2noise_val
from openpiv.filters import replace_outliers
from openpiv.scaling import uniform
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from majordome.utilities import progress_bar


@dataclass
class PivConfig:
    """ Configuration to process files with OpenPIV.

    Attributes
    ----------
    time_step: float
        Time-step between consecutive images in seconds.
    scaling_factor: float
        Scaling factor from pixel to desired metric.
    window_size: int = 32
        Interrogation window size in pixels.
    search_area_size: int = 40
        Search windows size in pixels.
    overlap: int = 16
        Overlap between sliding windows in search.
    correlation_method: str = "linear"
        Correlation method (linear or circular).
    subpixel_method: str = "parabolic"
        Subpixel method (centroid, gaussian or parabolic).
    sig2noise_method: str = "peak2mean"
        Signal extraction method (peak2peak or peak2mean).
    peak_width_ignore: int = 1
        Width to ignore around peak when using `peak2peak` method.
    percentile: float = 5.0
        Percentile of data to be considered as outliers.
    min_sr: float = 1.05
        Minimum S/R to be considered valid data. Notice that if the
        threshold computed with `percentile` is below this value it
        is ignore and `min_sr` is used instead.
    outlier_method: str = "localmean"
        Outlier filter method (localmean, disk or distance).
    outlier_kernel_size: int = 2
        Outlier filter kernel size.
    outlier_max_iter: int = 100
        Outlier filter maximum iterations.
    outlier_tol: float = 0.0001
        Outlier filter tolerance.
    arrow_width: float = 0.003
        Width of arrows to draw over plot.
    arrow_scale: float = 300_000
        Multiplier to provide scaling to the arrows over plot.
    """
    time_step: float
    scaling_factor: float
    window_size: int = 32
    search_area_size: int = 40
    overlap: int = 16
    correlation_method: str = "linear"
    subpixel_method: str = "parabolic"
    sig2noise_method: str = "peak2mean"
    peak_width_ignore: int = 1
    percentile: float = 5.0
    min_sr: float = 1.05
    outlier_method: str = "localmean"
    outlier_kernel_size: int = 2
    outlier_max_iter: int = 100
    outlier_tol: float = 0.0001
    arrow_width: float = 0.003
    arrow_scale: float = 300_000

    def threshold(self, s2n: np.ndarray):
        """ Compute signal-to-noise threshold to drop outliers. """
        return max(self.min_sr, np.percentile(s2n, self.percentile))


def piv_workflow(
    conf: PivConfig,
    images: list[str | Path],
    output_dir: str | Path,
    every: Optional[int] = 1
) -> pd.DataFrame:
    """ Process a batch of sequential images provided in list.

    Parameters
    ----------
    conf: PivConfig
        Configuration object with OpenPIV parameters.
    images: list[PathLike]
        List of sorted images to run in batch mode.
    output_dir: PathLike
        Path to directory to generate output files.
    every: Optional[int] = 1
        Step between consecutive files in list to compute velocities.

    Returns
    -------
    pd.DataFrame
        Data frame with time, mean velocities and standard deviations.
    """
    df = pd.DataFrame(columns=["t", "u_mean", "u_std", "v_mean",
                               "v_std",  "s_mean", "s_std"])
    names = ["x", "y", "u", "v", "mask"]

    pairs = zip(images[:-every], images[every:])
    pbar = progress_bar(pairs, size=len(images)-1, enum=True)

    for count, (file_a, file_b) in pbar:
        savehist = output_dir / f"transition_{count:04d}_hist.png"
        saveimgs = output_dir / f"transition_{count:04d}_imgs.png"
        datafile = output_dir / f"transition_{count:04d}_data.dat"

        _pair_process(conf, file_a, file_b, datafile,
                      savehist=savehist, saveimgs=saveimgs,
                      counter=count)

        data = pd.read_csv(datafile, sep="\t", skiprows=1, names=names)
        data["s"] = np.sqrt(pow(data["u"], 2) + pow(data["v"], 2))

        t = (count / every) * conf.time_step
        row = data.describe().T[["mean", "std"]].loc[["u", "v", "s"]]
        df.loc[count] = t, *row.to_numpy().flatten()

    df.to_csv(output_dir / "results.csv", index=False)

    return df


def _pair_process(
    conf: PivConfig,
    file_a: str | Path,
    file_b: str | Path,
    datafile: str | Path,
    savehist: Optional[str | Path] = None,
    saveimgs: Optional[str | Path] = None,
    counter: Optional[int] = 0,
    every: Optional[int] = 1,
    figsize: Optional[tuple[float, float]] = (12, 12),
    dpi: Optional[int] = 150
) -> None:
    """ Process a pair of images and generates velocity table.

    Parameters
    ----------
    conf: PivConfig
        Configuration object with OpenPIV parameters.
    file_a: PathLike
        Path to first file in the frame series.
    file_b: PathLike
        Path to second file in the frame series.
    datafile: PathLike
        Path to dump extracted data file.
    savehist: Optional[PathLike] = None
        If provided, save S/N ratio histogram to this file.
    saveimgs: Optional[PathLike] = None
        If provided, save sequence of images to this file.
    counter: Optional[int] = 0
        If provided, index first image in the series with this value.
    every: Optional[int] = 1
        Step between consecutive files in list to compute velocities.
    figsize: Optional[FigSize] = (12, 12)
        Figure size to be provided to `matplotlib.
    dpi: Optional[int] = 150
        Figure pixel density to be provided to `matplotlib.
    """
    frame_a = imread(file_a).astype(np.int32)
    frame_b = imread(file_b).astype(np.int32)

    u, v, s2n = extended_search_area_piv(
        frame_a, frame_b,
        window_size=conf.window_size,
        overlap=conf.overlap,
        dt=conf.time_step,
        correlation_method=conf.correlation_method,
        subpixel_method=conf.subpixel_method,
        sig2noise_method=conf.sig2noise_method,
        width=conf.peak_width_ignore,
        search_area_size=conf.search_area_size,
        normalized_correlation=True
    )

    threshold = conf.threshold(s2n)

    u, v, mask = sig2noise_val(u, v, s2n=s2n, w=None,
                               threshold=threshold)

    u, v = replace_outliers(u, v, w=None,
                            method=conf.outlier_method,
                            max_iter=conf.outlier_max_iter,
                            tol=conf.outlier_tol,
                            kernel_size=conf.outlier_kernel_size)

    x, y = get_coordinates(image_size=frame_a.shape,
                           search_area_size=conf.search_area_size,
                           overlap=conf.overlap)

    x, y, u, v = uniform(x, y, u, v, scaling_factor=conf.scaling_factor)
    x, y, u, v = transform_coordinates(x, y, u, v)

    txtsave(x, y, u, v, mask, datafile)

    if savehist is not None:
        plot_histogram(s2n, threshold).savefig(savehist, dpi=dpi)

    if saveimgs is not None:
        plot_images(frame_a, frame_b, datafile, file_a, counter, every,
                    conf.scaling_factor, conf.window_size,
                    conf.arrow_scale, conf.arrow_width,
                    figsize=figsize).savefig(saveimgs, dpi=dpi)

    plt.close("all")


def plot_mean_speed(
    df: pd.DataFrame,
    figsize: Optional[tuple[float, float]] = (6, 5),
    add_bounds: Optional[bool] = True
) -> Figure:
    """ Plot mean measured speed over time from table.

    This function expects data frame as structured by an implementation
    of `piv_workflow`, *i.e.* with header names from that function.

    Parameters
    ----------
    df: pd.DataFrame
        Data frame as exported by `piv_workflow` implementation.
    figsize: Optional[FigSize] = (6, 5)
        Figure size to be provided to `matplotlib.
    add_bounds: Optional[bool] = True
        If `True`, display mean plus/minus one standard deviation.

    Returns
    -------
    Figure
        A `matplotlib` figure for further manipulation/dumping.
    """
    t = 1000 * df["t"].to_numpy()
    s_mean = df["s_mean"].to_numpy()
    s_std = df["s_std"].to_numpy()

    plt.close("all")
    plt.style.use("seaborn-white")
    fig = plt.figure(figsize=figsize)

    plt.plot(t, s_mean + 0 * s_std, label="$\\mu$")

    if add_bounds:
        plt.plot(t, s_mean + 1 * s_std, label="$\\mu + \\sigma$")
        plt.plot(t, s_mean - 1 * s_std, label="$\\mu - \\sigma$")

    plt.grid(linestyle=":")
    plt.xlabel("Time [ms]")
    plt.ylabel("Projected speed [mm/s]")
    plt.legend(loc=1, frameon=True)
    plt.tight_layout()

    return fig


def plot_histogram(
    s2n: np.ndarray,
    threshold: float,
    bins: Optional[int] = 50,
    figsize: Optional[tuple[float, float]] = (6, 5)
) -> Figure:
    """ Display signal-to-noise ratio histogram.

    Parameters
    ----------
    s2n: np.ndarray
        Array 2D of signal-to-noise values to plot distribution.
    threshold: float
        Threshold value to display point of cut-off over histogram.
    bins: Optional[int] = 50
        Number of bins to divide data over in histogram.
    figsize: Optional[FigSize] = (6, 5)
        Figure size to be provided to `matplotlib.

    Returns
    -------
    Figure
        A `matplotlib` figure for further manipulation/dumping.
    """
    plt.close("all")
    plt.style.use("seaborn-white")
    fig, ax = plt.subplots(figsize=figsize)

    ax.hist(s2n.flatten(), bins=bins)
    ax.axvline(threshold, color="k")
    ax.grid(linestyle=":")
    ax.set_xlabel("Ratio S/N")
    ax.set_ylabel("Count")

    fig.tight_layout()
    return fig


def plot_images(
    frame_a: Array,
    frame_b: Array,
    txtfile: str | Path,
    file_a: str | Path,
    counter: int,
    every: int,
    scaling_factor: float,
    window_size: int,
    arrow_scale: float,
    arrow_width: float,
    figsize: Optional[tuple[float, float]] = (8, 8)
) -> Figure:
    """ Display frames at different stages of development.

    Parameters
    ----------
    frame_a: Array
        First frame in the series.
    frame_b: Array
        Second frame in the series.
    txtfile: PathLike
        Path to data file with velocity profiles.
    file_a: PathLike
        Path to image file originating `frame_a`.
    counter: int
        Step number used to provide titles to the consecutive images.
    every: int
        Step between consecutive files in list to compute velocities.
    scaling_factor: float
        Conversion factor from pixels to millimeters.
    window_size: int
        Window size used during velocity profile extraction.
    arrow_scale: float
        Multiplier to provide scaling to the arrows over plot.
    arrow_width: float
        Width of arrows to draw over plot.
    figsize: Optional[FigSize] = (8, 8)
        Figure size to be provided to `matplotlib.

    Returns
    -------
    Figure
        A `matplotlib` figure for further manipulation/dumping.
    """
    # Compute difference between frames for speed intuitive view.
    frame_c = pow(frame_a, 2) - pow(frame_b, 2)

    plt.close("all")
    plt.style.use("seaborn-white")

    fig, ax = plt.subplots(2, 2, figsize=figsize)

    ax[0, 0].imshow(frame_a, cmap=plt.cm.hot)
    ax[0, 1].imshow(frame_b, cmap=plt.cm.hot)
    ax[1, 0].imshow(frame_c, cmap=plt.cm.hot)

    _display_vector_field(txtfile, window_size, ax[1, 1], image_name=file_a,
                          scaling_factor=scaling_factor, scale=arrow_scale,
                          width=arrow_width)

    ax[0, 0].grid(linestyle=":", color="k")
    ax[0, 1].grid(linestyle=":", color="k")
    ax[1, 0].grid(linestyle=":", color="k")
    ax[1, 1].grid(linestyle=":", color="k")

    ax[0, 0].set_title(f"Frame {counter + 0}")
    ax[0, 1].set_title(f"Frame {counter + every}")
    ax[1, 0].set_title("Movement shadows")
    ax[1, 1].set_title("Detected vectors")

    fig.tight_layout()

    return fig


def _display_vector_field(
        filename: str | Path, 
        window_size: int,
        ax: object,
        image_name: Optional[str | Path] = None,
        scaling_factor: Optional[int] = 1,
        width: Optional[float] = 0.0025, 
        scale: Optional[float] = 1.0
    ):
    """ Alternative to `openpiv.tools.display_vector_field`. """
    a = np.loadtxt(filename)
    x, y, u, v, mask = a[:, 0], a[:, 1], a[:, 2], a[:, 3], a[:, 4]

    if image_name is not None:
        im = negative(imread(image_name))
        xmax = np.amax(x) + window_size / (2 * scaling_factor)
        ymax = np.amax(y) + window_size / (2 * scaling_factor)
        ax.imshow(im, cmap="Greys_r", extent=[0.0, xmax, 0.0, ymax])

    invalid = mask.astype("bool")
    valid = ~invalid

    xv, yv, xi, yi = x[valid], y[valid], x[invalid], y[invalid]
    uv, vv, ui, vi = u[valid], v[valid], u[invalid], v[invalid]

    # TODO add alternative color scale based on sqrt(u**2 + v**2)!
    ax.quiver(xi, yi, ui, vi, color="r", width=width, scale=scale)
    ax.quiver(xv, yv, uv, vv, color="b", width=width, scale=scale)
