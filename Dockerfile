# AESD Course Project Dockerfile for building yocto images
FROM ubuntu:18.04

# Default end result image and target, can be overwritten with `docker build`
ARG MACHINE="jetson-nano-2gb-devkit"
ARG BRANCH="gatesgarth"
ARG DISTRO="tegrademo-mender build-tegrademo-mender"
ARG BUILD_IMAGE="demo-image-full"

# Install build system's dependencies
RUN apt-get update 
RUN apt-get -y upgrade
# Remote Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-utils \
    gawk \
    git \
    wget \
    git-core \
    subversion \
    screen \
    tmux \
    sudo \
    iputils-ping \
    iproute2 \
    tightvncserver \
    apt-transport-https \
    ca-certificates \
    curl

# Build Tools
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    make \
    cmake \
    gcc \
    gcc-multilib \
    g++-multilib \
    gcc-8 \
    g++-8 \
    clang-format \
    clang-tidy \
    cpio \
    diffstat \
    build-essential \
    bmap-tools \
    vim \
    nano \
    bash-completion \
    gnupg \
    lsb-release

# Development Libraries
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libegl1-mesa \
    libsdl1.2-dev \
    libasio-dev \
    libtinyxml2-dev \
    libcppunit-dev \
    libzstd-dev \
    libbenchmark-dev \
    libspdlog-dev \
    liblog4cxx-dev \
    libcunit1-dev

# Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

# Python Packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python \
    python3 \
    python-rosdep \
    python3-pip \
    python3-pexpect \
    python3-git \
    python3-jinja2 \
    python3-colcon-common-extensions \
    python3-vcstool \
    python3-babeltrace \
    python3-pygraphviz \
    python3-mock \
    python3-nose \
    python3-mypy \
    python3-pytest-mock \
    python3-lttng

# Nvidia and other Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    dkms \
    iputils-ping  \
    mesa-utils \
    debianutils \
    libnvidia-container1 \
    libnvidia-container-tools \
    pylint3 \
    xterm \
    unzip \
    sysstat \
    texinfo \
    chrpath \
    socat \
    xz-utils  \
    locales \
    fluxbox

# Upgrade Python's package installer
RUN pip3 install -U pip

### Setup Build Environment ###
# User management
RUN groupadd -g 1000 aesd && \
    useradd -u 1000 -g 1000 -ms /bin/bash aesd && \
    usermod -a -G sudo aesd && \
    usermod -a -G users aesd && \
    mkdir /home/aesd && \
    chown -R aesd:aesd /home/aesd
RUN rm /bin/sh && ln -s bash /bin/sh
RUN install -o 1000 -g 1000 -d /home/aesd

# Set environment
RUN dpkg-reconfigure locales
RUN locale-gen en_US.UTF-8
ENV LANG en_us.UTF-8
ENV LC_ALL en_US.UTF-8
RUN update-locale
COPY ./bashrc /home/aesd/.bashrc
RUN sudo sysctl fs.inotify.max_user_watches=65536
WORKDIR /home/aesd
USER aesd

# Clean up a bit
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Begin the Yocto Build for Jetson Image
COPY tegra_builder.sh .
RUN chmod a+x tegra_builder.sh
CMD [ "bash", "-c", "./tegra_builder.sh" ]
