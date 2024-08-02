##############################################################################
# GPU ENABLED JUPYTERHUB AND MASTER SCIENTIFIC ENVIRONMENT
##############################################################################

FROM ubuntu:20.04
LABEL authors="Walter Dal'Maz Silva <walter.dalmazsilva@gmail.com>"

# Define environment to avoid later prompts.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add base service directory/group.
RUN groupadd jupyterusers
RUN mkdir -p /srv/jupyterhub/
WORKDIR /srv/jupyterhub/

# Ensure base system is up-to-date.
RUN apt update && apt upgrade -y

# Install Linux basics for build/install.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        apt-transport-https \
        apt-utils \
        autoconf \
        automake \
        build-essential \
        ca-certificates \
        curl \
        dirmngr \
        gnupg \
        locales \
        software-properties-common \
        wget

##############################################################################
# COMMON UTILITIES AND LIBRARIES
##############################################################################

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'

# Extra required to build R.
RUN add-apt-repository ppa:openjdk-r/ppa

# General Linux utilities.
RUN apt update && \
    apt install --no-install-recommends -y \
        bison \
        ccache \
        cgns-convert \
        clang-9 \
        clang-format-9 \
        clang-tidy-9 \
        cmake \
        cmake-curses-gui \
        doxygen \
        fftw3-dev \
        g++ \
        g++-7 \
        gcc \
        gcc-7 \
        gdb \
        gfortran \
        git \
        graphviz \
        haskell-platform \
        htop \
        jq \
        julia \
        lcov \
        libblas-dev \
        libboost-all-dev \
        libbz2-dev \
        libcairo2-dev \
        libcgns-dev \
        libcurl4-openssl-dev \
        libffi-dev \
        libfftw3-dev \
        libgdbm-dev \
        libgl1-mesa-glx \
        libgl1-mesa-glx \
        libgsl-dev \
        libhdf5-dev \
        libhdf5-openmpi-dev \
        liblapack-dev \
        liblapacke-dev \
        liblzma-dev \
        libmagic-dev \
        libncurses5-dev \
        libnss3-dev \
        libopenblas-dev \
        libopenmpi-dev \
        libpango1.0-dev \
        libpcre2-dev \
        libpng-dev \
        libqt5widgets5 \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        libthrust-dev \
        libtiff5-dev \
        libtinfo-dev \
        libtool \
        libxext6 \
        libxml2-dev \
        libxrender1 \
        libxt6 \
        libzmq3-dev \
        lua5.3 \
        lzma \
        lzma-dev \
        make \
        mpich \
        ninja-build \
        octave \
        openjdk-11-jre \
        openmpi-bin \
        openmpi-common \
        openssh-client \
        petsc-dev \
        pkg-config \
        r-base \
        rsync \
        ssh \
        swig \
        tar \
        texlive-full \
        tk8.6-dev \
        uuid-dev \
        vim \
        wget \
        xvfb \
        zlib1g-dev

##############################################################################
# GENERAL CUDA ENVIRONMENT
##############################################################################

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
    mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub && \
    add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" && \
    apt-get update && \
    apt-get install -y nvidia-kernel-source-460 && \
    apt-get install -y \
        cuda \
        nvidia-cuda-toolkit

COPY libs/libcudnn8*11.2*.deb  /tmp/
RUN cd /tmp/ && apt-get install -y dpkg                     && \
    dpkg -i libcudnn8_8.1.1.33-1+cuda11.2_amd64.deb         && \
    dpkg -i libcudnn8-dev_8.1.1.33-1+cuda11.2_amd64.deb     && \
    dpkg -i libcudnn8-samples_8.1.1.33-1+cuda11.2_amd64.deb && \
    rm -rf /tmp/libcudnn8*11.2*.deb

# Install nvtop for monitoring GPU.
RUN apt install -y nvtop

##############################################################################
# INSTALL LANGUAGE FEATURES/MORE LANGUAGES
##############################################################################

RUN cd /tmp/ && \
    git clone --recursive https://github.com/python/cpython.git && \
    cd /tmp/cpython && \
    git checkout tags/v3.8.12 && \
    ./configure \
        --enable-optimizations \
        --with-lto \
        --enable-shared && \
    make -j `nproc` && \
    make test && \
    make install && \
    ldconfig && \
    rm -rf /tmp/cpython

# Up-to-date python.
RUN python3 -m pip install --upgrade setuptools pip wheel

# Create python environment.
COPY config/requirements.txt .
RUN apt remove -y python3-terminado && \
    pip3 install -r requirements.txt && \
    python3 -m lua_kernel.install && \
    rm -rf requirements.txt

# Install recent NodeJS.
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt install -y nodejs

# Install Jupyterhub.
RUN npm install -g configurable-http-proxy && \
    pip3 install 'jupyterhub<=2.0.0'

# Create R environment.
COPY config/rpkgs.r .
RUN Rscript rpkgs.r && \
    R -e 'IRkernel::installspec(user = FALSE)'

# Install jupyter extensions.
RUN pip3 install --upgrade jupyterlab jupyterlab-git
RUN jupyter labextension install jupyterlab-plotly
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager plotlywidget
RUN jupyter labextension install @techrah/text-shortcuts
RUN jupyter labextension install jupyterlab-spreadsheet
RUN pip3 install \
    jupyterlab-execute-time \
    jupyterlab-drawio \
    jupyterlab_theme_solarized_dark \
    jupyter_bokeh \
    ipympl \
    lckr-jupyterlab-variableinspector

# Copy configuration file.
COPY config/jupyterhub_config.py .

##############################################################################
# SIMULATION
##############################################################################

# Install Haskell Stack.
RUN curl -sSL https://get.haskellstack.org/ | sh

# Install Modelica.
RUN echo "deb https://build.openmodelica.org/apt `lsb_release -cs` stable" | \
    tee /etc/apt/sources.list.d/openmodelica.list && \
    wget -q http://build.openmodelica.org/apt/openmodelica.asc -O- | apt-key add - && \
    apt-key fingerprint && apt update && apt install -y openmodelica

# Install OpenFOAM ESI
RUN curl -s https://dl.openfoam.com/add-debian-repo.sh | bash && \
    wget -q -O - https://dl.openfoam.com/add-debian-repo.sh | bash && \
    apt update && apt install -y openfoam2112-default

# Install OpenFOAM ORG
RUN sh -c "wget -O - https://dl.openfoam.org/gpg.key | apt-key add -" && \
    add-apt-repository http://dl.openfoam.org/ubuntu && \
    apt update && apt install -y openfoam9

# Install FEniCS.
# XXX: https://fenics.readthedocs.io/en/latest/installation.html
RUN add-apt-repository ppa:fenics-packages/fenics && \
    apt update && apt -y install fenics

# Install lammps docker-scientific-ubuntu-gpu
# XXX: only for now, later compile it.
RUN add-apt-repository ppa:gladky-anton/lammps && \
    add-apt-repository ppa:openkim/latest && \
    apt update && apt install -y \
        lammps-stable \
        lammps-stable-data \
        openkim-models

# Install ESPResSo MD.
COPY build/espresso.sh .
COPY config/myconfig-espresso.h .
RUN chmod +x espresso.sh && ./espresso.sh

# Install SU2.
COPY build/su2.sh .
RUN chmod u+x su2.sh && ./su2.sh

# TODO OpenCalphad: automate Makefile edition.
COPY build/opencalphad.sh .
RUN cd /opt/ && git clone https://github.com/sundmanbo/opencalphad.git

# Install Cantera.
COPY build/cantera.sh .
RUN chmod u+x cantera.sh && ./cantera.sh

##############################################################################
# PATCHES
##############################################################################

RUN ln -s /opt/cantera/lib/python3.8/site-packages/cantera \
    /usr/local/lib/python3.8/site-packages/ && \
    ln -s /opt/cantera/lib/python3.8/site-packages/Cantera-2.5.1-py3.8.egg-info \
    /usr/local/lib/python3.8/site-packages/ && \
    sed -i  "s|which python|which python3|g" /opt/cantera/bin/setup_cantera

# https://doc.sagemath.org/html/en/installation/index.html
# https://doc.sagemath.org/html/en/installation/launching.html
RUN apt-get remove -y sagemath && \
    apt-get install -y python3-venv && \
    wget http://www-ftp.lip6.fr/pub/math/sagemath/linux/64bit/sage-9.4-Ubuntu_20.04-x86_64.tar.bz2 && \
    tar -xf sage-9.4-Ubuntu_20.04-x86_64.tar.bz2 -C /opt && \
    cd /opt/SageMath && ./sage -c "exit()" && \
    ln -s /opt/SageMath/sage /usr/local/bin/sage && \
    jupyter kernelspec install /opt/SageMath/local/share/jupyter/kernels/sagemath && \
    rm -rf sage-9.4-Ubuntu_20.04-x86_64.tar.bz2

##############################################################################
# ENTRYPOINT
##############################################################################

COPY config/README.md .
COPY config/bashrc.sh .
COPY config/make_users.sh .
RUN chmod +x make_users.sh

EXPOSE 8000
EXPOSE 8333

RUN apt clean

ENTRYPOINT []

##############################################################################
# EOF
##############################################################################