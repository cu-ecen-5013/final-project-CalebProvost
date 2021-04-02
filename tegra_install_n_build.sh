#!/bin/bash

# Set output directory to yocto_build if WORKDIR isn't set
[ -z "${MACHINE}" ] && export MACHINE="jetson-nano-2gb-devkit"
[ -z "${BRANCH}" ] && export BRANCH="c4ef10f44d92ac9f1e4725178ab0cefd9add8126"
[ -z "${DISTRO}" ] && export DISTRO="tegrademo"
[ -z "${BUILD_IMAGE}" ] && export BUILD_IMAGE="demo-image-full"
[ -z "${NVIDIA_DEVNET_MIRROR}" ] && export NVIDIA_DEVNET_MIRROR="file:///home/aesd/sdk_downloads"

# Installs the nVidia SDK
# sdkmanager --cli install --staylogin true --product Jetson --version 4.5.1 --targetos Linux --host true --target P3448-0003 --flash skip --select "Jetson OS" --license accept --datacollection disable --downloadfolder /media/aesd/yocto/sdk_downloads --targetimagefolder /media/aesd/yocto/nvidia_sdk/ --sudopassword '\n'
sdkmanager --cli install --staylogin true --product Jetson --version 4.5.1 \
    --targetos Linux --host true --target P3448-0003 --flash skip \
    --additionalsdk TensorFlow --select "Jetson OS" --select "Jetson SDK Components" \
    --license accept --datacollection disable --downloadfolder /home/aesd/sdk_downloads \
    --targetimagefolder /home/aesd/nvidia/nvidia_sdk/ --sudopassword '\n'

# git clone https://github.com/OE4T/meta-tegra.git
git clone https://github.com/OE4T/tegra-demo-distro.git /home/aesd/tegra-demo-distro
cd /home/aesd/tegra-demo-distro/ || exit 1
git checkout ${BRANCH}
git submodule update --init --recursive
. ./setup-env --machine ${MACHINE} --distro ${DISTRO}
bitbake ${BUILD_IMAGE}
