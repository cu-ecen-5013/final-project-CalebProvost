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

YL4T_SUCCESS="false"
git clone https://github.com/OE4T/tegra-demo-distro.git /home/aesd/tegra-demo-distro
cd /home/aesd/tegra-demo-distro/ || exit 1
git checkout ${BRANCH}
git submodule update --init --recursive
. ./setup-env --machine ${MACHINE} --distro ${DISTRO}

# Add Project Layer
cd /home/aesd/tegra-demo-distro/layers/ || exit 1
git clone https://github.com/cu-ecen-5013/final-project-CalebProvost.git --branch yocto-layer meta-aesd-final
cd /home/aesd/build/ || exit 1
bitbake-layers add-layer /home/aesd/tegra-demo-distro/layers/meta-aesd-final

bitbake ${BUILD_IMAGE} && export YL4T_SUCCESS="true"

if [ "${YL4T_SUCCESS}" = "true" ]; then
    echo "Yocto Build of L4T Complete. Preping Image to flash to SD Card."
    mkdir -p /home/aesd/tegraflash
    cd /home/aesd/tegraflash || echo "Could not enter staging directory" && exit 1
    # cp "/home/aesd/tegra-demo-distro/build/tmp/deploy/images/${MACHINE}/${BUILD_IMAGE}-${MACHINE}.tegraflash.tar.gz" /home/aesd/tegraflash/
    tar -xf "/home/aesd/tegra-demo-distro/build/tmp/deploy/images/${MACHINE}/${BUILD_IMAGE}-${MACHINE}.tegraflash.tar.gz"
    ./dosdcard "${BUILD_IMAGE}-${MACHINE}.img"
    mv "${BUILD_IMAGE}-${MACHINE}.img" /home/aesd/
    SDIMAGE="/home/aesd/${BUILD_IMAGE}-${MACHINE}.img"
    
    echo "###############################################"
    echo "Yocto has built the L4T image. You can find the deloyment files here: /home/aesd/tegra-demo-distro/build/tmp/deploy/images/${MACHINE}/"
    echo "For your conveinence, we've prepped an SD Card image for you to flash here: ${SDIMAGE}"
    echo "###############################################"
exit 0
else
    echo "Could not determine the success of Yocto building L4T; exiting..."
    exit 1
fi
