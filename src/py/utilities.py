# -*- coding: utf-8 -*-
from io import StringIO
from pathlib import Path
from time import perf_counter
from typing import Iterator
from typing import Optional
import sys
import shutil
import requests


class Capturing(list):
    """ Helper to capture excessive solver output.

    In some cases, specially when running from a notebook, it might
    be desirable to capture solver (here Ipopt specifically) output
    to later check, thus avoiding a overly long notebook.  For this
    end this context manager is to be used and redirect to a list.
    """
    def __enter__(self):
        self._stdout = sys.stdout
        self._stderr = sys.stderr
        sys.stdout = self._tmpout = StringIO()
        sys.stderr = self._tmperr = StringIO()
        return self

    def __exit__(self, *args):
        self.extend(self._tmpout.getvalue().splitlines())
        self.extend(self._tmperr.getvalue().splitlines())
        del self._tmpout
        del self._tmperr
        sys.stdout = self._stdout
        sys.stderr = self._stderr


# TODO: provide all of these stackoverflow.com/questions/4842424

class TextColor:
    """ Basic text colors for happy terminal print. """
    BLACK = "\u001b[30m."
    RED = "\u001b[31m."
    GREEN = "\u001b[32m."
    YELLOW = "\u001b[33m."
    BLUE = "\u001b[34m."
    MAGENTA = "\u001b[35m."
    CYAN = "\u001b[36m."
    WHITE = "\u001b[37m."


class ProgressBar:
    """ Simple progress bar with duration estimation for simulation tracking.
    
    This basic progress bar display process status advance on the screen and
    also total run-time and e.t.a (estimated time of arrival). It is extremely
    minimalist and cannot handle overflow, thus it is up to the user to ensure
    terminal will be at least 79 characters wide.

    Parameters
    ----------
    ncols: Optional[int] = 40
        Number of columns used for bar tracing.
    marker: Optional[str] = "█"
        Single character used for filling up the bar.
    """
    def __init__(self,
            ncols: Optional[int] = 40,
            marker: Optional[str] = "█"
        ) -> None:
        self._nc = ncols + 1.0e-06
        self._mk = marker[:1]
        self._t0 = perf_counter()
        self._duration = None

        base = ("\r|{{0:{ncols}s}}| {{1:3.0f}}% "
                "[run {{2:.2e}}s | eta {{3:.2e}}s]")
        self._txt = base.format(ncols=ncols)

    def update(self, frac: float) -> None:
        """ Update fraction of bar filling.
        
        Parameters
        ----------
        frac: float
            Current status of filling to apply to the bar.
        """
        stat = int(self._nc * frac)

        mark = self._mk * stat
        fill = 100 * stat / self._nc

        run = perf_counter() - self._t0
        eta = float("nan") if fill <= 0.0 else 100 * run / fill - run

        sys.stdout.write(self._txt.format(mark, fill, run, eta))
        sys.stdout.flush()

        self._duration = run

    @property
    def duration(self):
        """ Return total wall time of process. """
        if self._duration is None:
            raise ValueError("Progress not yet measured.")
        return self._duration


def progress_bar(
        array: list[object] | Iterator,
        ncols: Optional[int] = 40,
        marker: Optional[str] = "█",
        size: Optional[int] = None,
        enum: Optional[bool] = False
    ):
    """ Wrapper to use progress bar as iterator.
    
    Parameters
    ----------
    array: list[object] | Iterator
        List of iterator of objects to track progression. 
    ncols: Optional[int] = 40
        Number of columns used for bar tracing.
    marker: Optional[str] = "█"
        Single character used for filling up the bar.
    size: Optional[int] = None
        If `array` does not have a length, *i.e*, it is an iterator,
        the size of the provided object is mandatory and provided
        through this parameters.
    enum: Optional[bool] = False
        If true, return the zero based object counter.
    """
    size = size if size is not None else len(array)
    pbar = ProgressBar(ncols=ncols, marker=marker)

    for count, value in enumerate(array, 1):
        pbar.update(count / size)
        yield value if not enum else (count - 1, value)

    print(f"\nTook {pbar.duration}s")


def get_current_file_directory(the_file: str) -> Path:
    """ Wrapper to get path to current file directory.
    
    This is a simple abstraction to avoid calling the returned sequence
    everytime. This is useful to handling load of internal configuration
    files in packages. Simply call with `__file__` as argument.

    Parameters
    ----------
    the_file : str
        File to have its parent path determined, generally magic
        string `__file__` in packages.

    Returns
    -------
    Path
        The resolved parent path of required file.
    """
    return Path(the_file).resolve().parent


def get_configuration_file(the_file: str, conf_relative_path: str) -> Path:
    """ Wrapper to get path of a configuration file relative to parent.
    
    Parameters
    ----------
    the_file : str
        File to have its parent path determined, generally magic
        string `__file__` in packages.
    conf_relative_path : str
        Relative path of configuration file from parent directory.

    Returns
    -------
    Path
        The resolved path of required configuration file.
    """
    return get_current_file_directory(the_file) / conf_relative_path


def download_file(url: str, saveas: str | Path):
    """ Download file from given URL and destination path.

    Reference
    ---------
    https://stackoverflow.com/questions/34692009

    Parameters
    ----------
    url : str
        URL of file to download.
    saveas : path-like
        Path to save downloaded file.
    """
    r = requests.get(url, stream=True)
    status = r.status_code

    match status:
        case 200:
            with open(saveas, "wb") as fp:
                r.raw.decode_content = True
                shutil.copyfileobj(r.raw, fp)
        case _:
            Exception(f"Download of {url} failed with status {status}")
