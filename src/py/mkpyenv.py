# -*- coding: utf-8 -*-
"""
Make a portable (Windows) Python distribution
==============================================

Creates a embeddable Python distribution with pre-installed packages.

This is intended for ease of packaging under Windows 10+.

Configuration
-------------

Configuration of the distribution can be done with a JSON file provided
through command line with the following example structure, where all
arguments are optional (by default it will install python from the web).

```json
{
    "python_zip": "/path/to/python-3.7.5-embed-amd64.zip",
    "get_pip": "get-pip.py",
    "url_py": "https://path/to/python.zip",
    "url_pip": "https://path/to/get-pip.py",
    "build_dir": "build",
    "py_name": "python",
    "pkg_tarbz2": [
        "package-name.tar.bz2"
    ],
    "deps": [
        "numpy",
        "scipy",
        "matplotlib",
        "pandas"
    ]
}
```

Arguments
---------

- python_zip
    Path to the embeddable Python distribution. If it is not provided
    the script will try to download from `url_py`.
- url_py
    Address for download of embeddable Python distribution. By default
    if not provided the script will use variable `URLPY` defined below.
- get_pip
    Path to 'get-pip.py' file for installation of pip. If it is not
    provided the script will try to download from `url_pip`.
- url_pip
    Address for download of 'get-pip.py' script. By default if not
    provided the script will use variable `URLPIP` defined below.
- build_dir
    Path to directory to place embeddable Python. This path must be a
    relative path for safety reasons. Default is `embed`.
- py_name
    Name of Python directory under build_dir. If it already exists the
    script will raise an exception. Default is `python`.
- pkg_tarbz2
    List of tarballs containing extra packages that cannot be installed
    through 'pip' for some reason. Entries can be url's or paths.
- deps
    List of packages to be installed by pip.

To-Do
------

- Allow `deps` to be local wheel files.
- Support YAML configuration files.

Other
-----

Initially it was intended to support TKinter installation (check 
[this](https://stackoverflow.com/questions/37710205)) but now it has
been decided that PyQt5 is enough and better solution, requiring no
modifications to the script, simple list it as a dependency in
configuration file.
"""
from argparse import ArgumentParser
from pathlib import Path
from subprocess import Popen
from subprocess import PIPE
from subprocess import STDOUT
from typing import Union
import glob
import json
import logging
import os
import secrets
import shutil
import sys
import tarfile
import textwrap
import zipfile
import requests

from .utilities import download_file as mj_download_file

if sys.platform != "win32":
    raise SystemError("mkpyenv is supported only in Windows")

logger = logging.getLogger('mkpyenv')
logger.setLevel(logging.DEBUG)

fmt = '%(asctime)s: %(name)s-%(levelname)s: %(message)s'
formatter = logging.Formatter(fmt)

fh = logging.FileHandler(f'mkpyenv.log')
fh.setLevel(logging.DEBUG)
fh.setFormatter(formatter)

ch = logging.StreamHandler()
ch.setLevel(logging.ERROR)
ch.setFormatter(formatter)

logger.addHandler(fh)
logger.addHandler(ch)

TMP = Path(f'tmp-{secrets.token_hex(16)}')
URLPIP = 'https://bootstrap.pypa.io/get-pip.py'
PYTHON_ORG = 'https://www.python.org/ftp/python'

# VERSION has to be the same as current python interpreter.
VERSION = sys.version.split()[0]
URLPY = f'{PYTHON_ORG}/{VERSION}/python-{VERSION}-embed-amd64.zip'


def check_path(path: Union[str, Path]) -> Path:
    """ Helper for path consistency in module.

    Parameters
    ----------
    path : path-like
        Path to be tested for its type.

    Returns
    -------
    pathlib.Path
        Converted path to ensure pathlib compatibility.

    Raises
    ------
    ValueError
        If path is not a string or pathlib.Path.
    """
    if not isinstance(path, (str, Path)):
        raise ValueError('Path must be a string or pathlib.Path!')
    return Path(path) if isinstance(path, str) else path


def ensure_dir(dirname):
    """ Ensure a deep directory exists.

    Parameters
    ----------
    dirname : path-like
        Relative or absolute path to directory whose existence to be assured.
    """
    try:
        if not check_path(dirname).exists():
            os.makedirs(dirname)
    except Exception as err:
        logger.error(f'While creating {dirname}: {err}')
        raise err


def download_file(url, saveas):
    """ Download file package for installing.

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
    ensure_dir(TMP)
    saveas = TMP / saveas
    try:
        mj_download_file(url, saveas)
    except Exception as err:
        logger.error(f'While downloading {url}: {err}')
        raise err
    return check_path(saveas)


class Manager:
    """ Create environment by unzipping files.

    conf : dict
        Configuration file dictionary.
    """
    __slots__ = [
        '_root',
        '_conf',
        '_path',
        '_embed',
        '_py_name',
        '_get_pip',
        '_python_zip'
    ]

    def __init__(self, conf):
        self._conf = conf
        self._root = Path(os.getcwd())
        # self._root = Path(__file__).resolve().parent
        # if os.getcwd() != str(self._root):
        #     raise RuntimeError('Must run from this file\'s directory!')

    def _get_path(self, var, default):
        """ Wrapper for ensuring Pathlib compatibility. """
        return check_path(self._conf.get(var, default))

    def _get_once(self, attr, fallback):
        """ Ensure attributes are built only once. """
        try:
            value = getattr(self, attr)
        except AttributeError:
            value = fallback()
        return value

    @property
    def embed(self):
        """ Path to build directory. """
        def fallback():
            build = self._get_path('build_dir', 'embed')
            if not build.is_absolute():
                self._embed = self._root / build
            else:
                self._embed = build
            return self._embed
        return self._get_once('_embed', fallback)

    @property
    def py_name(self):
        """ Name of Python installation in build directory. """
        def fallback():
            py_name = self._get_path('py_name', 'python')
            if py_name.is_absolute():
                raise ValueError('py_name must not be an absolute path!')
            self._py_name = self.embed / py_name
            return self._py_name
        return self._get_once('_py_name', fallback)

    @property
    def get_pip(self):
        """ Path to get_pip.py script. """
        def fallback():
            get_pip = self._get_path('get_pip', 'get-pip.py')
            if not get_pip.exists():
                url = self._conf.get('url_pip', URLPIP)
                get_pip = download_file(url, get_pip)
            self._get_pip = get_pip
            return self._get_pip
        return self._get_once('_get_pip', fallback)

    @property
    def python_zip(self):
        """ Path to minimal Python distribution. """
        def fallback():
            python_zip = self._get_path('python_zip', 'python.zip')
            if not python_zip.exists():
                url = self._conf.get('url_py', URLPY)
                python_zip = download_file(url, python_zip)
            self._python_zip = python_zip
            return self._python_zip
        return self._get_once('_python_zip', fallback)

    def _unzip_python(self):
        """ Unzip embeddable python to target directory. """
        logger.info('Unzipping python embedding')

        if not self.python_zip.exists():
            raise FileNotFoundError(self.python_zip)

        if self.py_name.exists():
            raise FileExistsError(self.py_name)

        try:
            with zipfile.ZipFile(self.python_zip, 'r') as zip_ref:
                zip_ref.extractall(self.py_name)
        except Exception as err:
            logger.error(f'While unzipping {self.python_zip}: {err}')
            raise err

    def _allow_local(self):
        """ Allow local imports and pip to function.

        TODO do this with a regex for perenity.

        Reference
        ---------
        https://stackoverflow.com/questions/42666121
        """
        logger.info('Allowing local packages installation')
        python_pth = str(self.py_name / 'python*._pth')
        line = 'import site'
        for fname in glob.glob(python_pth):
            try:
                if not Path(fname).exists():
                    raise FileNotFoundError(fname)

                with open(fname, 'r') as fp:
                    content = fp.read()

                with open(fname, 'w') as fp:
                    fp.write(content.replace(f'#{line}', line))
            except Exception as err:
                logger.error(f'While fixing {fname}: {err}')
                raise err

    def _install_tarballs(self):
        """ Add tarball package to embedded python. """
        tarballs = self._conf.get('pkg_tarbz2', [])
        if not tarballs:
            logger.info('No tarball to install')

        for pkg in tarballs:
            logger.info(f'Installing package {pkg}')

            if pkg.startswith('http'):
                pkg = download_file(pkg, pkg.split('/')[-1])

            try:
                if not pkg.exists():
                    raise FileNotFoundError(pkg)

                with tarfile.open(pkg, 'r:bz2') as tar_ref:
                    tar_ref.extractall(self.py_name)
            except Exception as err:
                logger.error(f'While installing {pkg}: {err}')

    def __test_if_pip(self):
        """ Test if pip is installed in embedding. """
        proc = Popen(
            ['./python', '-m', 'pip', '--version'],
            stdout=PIPE,
            stderr=STDOUT
        )
        output, _ = proc.communicate()
        logger.info(output.decode('utf-8'))
        return proc.returncode

    def __install_pip(self):
        """ Run process for installing pip. """
        proc = Popen(
            ['./python', 'get-pip.py'],
            stdout=PIPE,
            stderr=STDOUT
        )
        output, _ = proc.communicate()
        logger.info(output.decode('utf-8'))
        os.unlink(str(self.py_name / 'get-pip.py'))
        return proc.returncode

    def _install_pip(self):
        """ Install pip to embedded python. """
        logger.info('Installing pip')

        try:
            shutil.copy(self.get_pip, self.py_name)
            os.chdir(self.py_name)

            if self.__test_if_pip() == 0:
                return

            if self.__install_pip() != 0:
                raise RuntimeError('Could not get pip installed!')
        except Exception as err:
            logger.error(f'While installing pip: {err}')
            raise err

    def _install_deps(self):
        """ Install desired dependencies to embedding. """
        logger.info('Installing dependencies')
        deps = self._conf.get('deps', [])
        if not deps:
            logger.info('No dependencies to install')

        # FIXME option --no-warn-script-location has no effect
        # FIXME adding to path has no effect either

        script = 'get-deps.py'
        with open(self.py_name / script, 'w') as fp:
            fp.write(textwrap.dedent(f"""\
                # -*- coding: utf-8 -*-
                import sys
                from subprocess import run

                sys.path.insert(0, r"{self.py_name}")
                sys.path.insert(0, r"{self.py_name}/Scripts")
                packages = [{', '.join([f'"{d}"' for d in deps])}]

                for pkg in packages:
                    cmd = ["./python", "-m", "pip", "install",
                           "--no-warn-script-location",
                           "--trusted-host", "pypi.org",
                           "--trusted-host", "files.pythonhosted.org"
                           ]
                    if run([*cmd, pkg]).returncode != 0:
                        print(f"Failed to install {{pkg}}")
                """))
        os.chdir(self.py_name)
        proc = Popen(
            ['./python', script],
            stdout=PIPE,
            stderr=STDOUT
        )
        output, _ = proc.communicate()
        logger.info(output.decode('utf-8'))
        os.unlink(str(self.py_name / script))

    def build(self):
        """ Manage building the embedded Python enviroment. """
        logger.info(f'Ensuring directory {self.embed} exists')
        ensure_dir(self.embed)

        self._unzip_python()
        self._allow_local()
        self._install_tarballs()
        self._install_pip()
        self._install_deps()


def main():
    """ Main function. """
    print(__doc__)

    parser = ArgumentParser('Create minimal Python embeddings')
    parser.add_argument('--config', action='store', dest='config',
                        help='path to JSON configuration file')
    args = parser.parse_args()

    config = {}
    if args.config is not None:
        if not Path(args.config).exists():
            print(f'Invalid configuration file: {args.config}')
            return 1

        with open(args.config) as fp:
            config = json.load(fp)

    Manager(config).build()
    return 0


if __name__ == '__main__':
    main()
