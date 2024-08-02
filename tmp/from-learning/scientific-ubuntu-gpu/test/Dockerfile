FROM ubuntu:20.04
LABEL authors="Walter Dal'Maz Silva <walter.dalmazsilva@gmail.com>"

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    ca-certificates \
    locales \
    dirmngr \
    gnupg \
    apt-transport-https \
    software-properties-common \
    wget

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin && \
    mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub && \
    add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" && \
    apt-get update && apt-get install -y nvidia-kernel-source-460 && \
    apt-get -y install -y cuda

RUN apt-get install -y nvidia-cuda-toolkit nvtop
RUN apt-get install -y python3-pip
RUN pip3 install tensorflow-gpu

COPY libs/libcudnn8*11.2*.deb  /tmp/
RUN cd /tmp/ && apt-get install -y dpkg                     && \
    dpkg -i libcudnn8_8.1.1.33-1+cuda11.2_amd64.deb         && \
    dpkg -i libcudnn8-dev_8.1.1.33-1+cuda11.2_amd64.deb     && \
    dpkg -i libcudnn8-samples_8.1.1.33-1+cuda11.2_amd64.deb && \
    rm -rf /tmp/libcudnn8*11.2*.deb

# RUN apt install -y \
#     libnvidia-compute-460 \
#     nvidia-utils-460 \
#     nvidia-cuda-dev \
#     nvidia-cuda-gdb \
#     nvidia-cuda-toolkit \
#     nvidia-cuda-toolkit-gcc
