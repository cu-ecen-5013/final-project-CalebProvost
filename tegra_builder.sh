#!/bin/bash

# Set output directory to yocto_build if WORKDIR isn't set
[ -z "${MACHINE}" ] && MACHINE="jetson-nano-2gb-devkit"
[ -z "${BRANCH}" ] && BRANCH="c4ef10f44d92ac9f1e4725178ab0cefd9add8126"
[ -z "${DISTRO}" ] && DISTRO="tegrademo"
[ -z "${BUILD_IMAGE}" ] && BUILD_IMAGE="demo-image-full"

# git clone https://github.com/OE4T/meta-tegra.git
git clone https://github.com/OE4T/tegra-demo-distro.git /home/aesd/tegra-demo-distro
cd /home/aesd/tegra-demo-distro/
git checkout ${BRANCH}
git submodule update --init --recursive
. ./setup-env --machine ${MACHINE} --distro ${DISTRO}
bitbake ${BUILD_IMAGE}
