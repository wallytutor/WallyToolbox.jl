# Jupyterhub Docker GPU

This repository provides a Docker environment consisting of a mixture of Data Science and CFD. The environment aims at serving JupyterHub with access to GPU and also allow OpenFOAM and SU2 from that platform. It is built to be an all-in-one system, with several scientific environments and languages available. To have it working some files need to be created and prepared before running `docker-compose` to create the environment.

0. Download compatible cudann libraries under `libs` directory and edit the following lines of [Dockerfile](./Dockerfile) for compatibility. You might also need to change `nvidia-kernel-source-470` to match your base OS driver.
    ```docker
    COPY libs/libcudnn8*11.2*.deb  /tmp/
    RUN cd /tmp/ && apt-get install -y dpkg                     && \
        dpkg -i libcudnn8_8.1.1.33-1+cuda11.2_amd64.deb         && \
        dpkg -i libcudnn8-dev_8.1.1.33-1+cuda11.2_amd64.deb     && \
        dpkg -i libcudnn8-samples_8.1.1.33-1+cuda11.2_amd64.deb && \
        rm -rf /tmp/libcudnn8*11.2*.deb
    ```

1. Create and edit `.env` to match the values you expect. The following commented snippet illustrates a possible content of this file with the required variables. A sample file is provided as [.env.sample](./.env.sample).
    ```bash
    # name of image, used to have parallel instances of this service.
    IMAGE_NAME=jupyterhub_gpu

    # mount point of `/home` for physical (local) storage of data
    # (a directory jupyterhub will be created at this location).
    PROJECTS_ROOT=$HOME

    # port to access/expose the hub locally/over a reverse proxy.
    PORT_JUPYTERHUB_URI=8000

    # port allow gogs access through ssh.
    PORT_GOGS_SSH=22

    # port to access/expose gogs locally/over a reverse proxy.
    PORT_GOGS_HTTPS=3000

    # memory of Nvidia GPU to be used.
    GPU_SHM_SIZE=4gb
    ```

1. Under `config` add the following files:

    - jupyterhub_config.py: configuration file as described [here](https://jupyterhub.readthedocs.io/en/stable/reference/config-reference.html). For version 1.5.0 of JupyterHub, the following snippet would create a PAM authentication system (the simplest one) with a single user called `user`. A sample file is provided as [config/jupyterhub_config.sample.py](./config/jupyterhub_config.sample.py).
    ```python
    c.JupyterHub.bind_url = 'http://0.0.0.0:8000/'
    c.Authenticator.admin_users = {'user'}
    c.Authenticator.allowed_users = {'user'}
    c.LocalAuthenticator.create_system_users = True
    ```

    - make_users.sh: script for adding users, setting passwords and rights. Notice that `jupyterhub_config.py` will not really create the users. This has to be done through the script `make_users.sh`. For creating a single `user` with password `SecretPass*1234` under the group `jupyterusers` (already created in Dockerfile) the following content could be added to this script. A sample file is provided as [config/make_users.sample.sh](./config/make_users.sample.sh).
    ```bash
    useradd -m -s /bin/bash -G jupyterusers user
    echo 'user:SecretPass*1234' | chpasswd
    ```

    - requirements.txt: typical `pip` file with Python packages to install following the directives provided [here](https://pip.pypa.io/en/stable/cli/pip_install/#requirement-specifiers). A sample file is provided as [config/requirements.txt](./config/requirements.txt).

    - rpkgs.r: an R-script managing the installation of required R packages. A sample script is provided below, where you are supposed to populate list `packages` to install all the globally installed packages in your environment. Notice the function `pkgLoad` is called in the end of script. A sample file is provided as [config/rpkgs.r](./config/rpkgs.r).
    ```R
    pkgLoad <- function()
    {
        repos <- "https://cran.irsn.fr"

        packages <- c("dplyr", "ggplot2")

        packagecheck <- match(packages, utils::installed.packages()[, 1])

        packagestoinstall <- packages[is.na(packagecheck)]

        if(length(packagestoinstall) > 0L) 
        {
            utils::install.packages(packagestoinstall, repos = repos)
        }

        for(package in packages) 
        {
            suppressPackageStartupMessages(
                library(package, character.only = TRUE, quietly = TRUE)
            )
        }
    }

    pkgLoad()
    ```

1. After filling all the files run `docker-compose up --build` or `docker-compose up -d`, as required.

1. Follow instructions under [config](./config) for making different packages available.

If deployment with external access is required, a sample Nginx configuration file is provided [here](config/jupyterhub.conf). You need to set your external domain and port number on this file before placing it under `/etc/nginx/conf.d` and running `systemctl reload nginx`. Notice that SSL is not configured and you will need `certbot` to protect your connection.

**NOTE:** check if base image is compatible with local GPU through `cat /proc/driver/nvidia/version` or `nvidia-smi`.

---

## Base contents of the container

The following languages/dialects are supported in Notebooks:

- Python
- Lua
- Octave
- SageMath
- R

The following languages are installed, users must add their own kernels:

- Julia
- Haskell

For general CLI development only there is also:

- C/C++
- Fortran
- NodeJS

---

## References

For maintenance of this container in the future consider the following references:

- https://hub.docker.com/r/nvidia/cuda/tags
- https://hub.docker.com/r/jupyterhub/jupyterhub
- https://pypi.org/project/jupyterhub/2.0.0/
- https://github.com/gibiansky/IHaskell
- https://irkernel.github.io/installation/
- https://stackoverflow.com/questions/47615751
- https://askubuntu.com/questions/876240
- https://askubuntu.com/questions/313089
- https://bugs.openfoam.org/view.php?id=3163
- https://stackoverflow.com/questions/48767595
