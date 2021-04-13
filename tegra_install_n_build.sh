#!/bin/bash

# Set output directory to yocto_build if WORKDIR isn't set
CUR_DIR=$(pwd)
[ -z "${MACHINE}" ] && export MACHINE="jetson-nano-2gb-devkit"
[ -z "${BRANCH}" ] && export BRANCH="c4ef10f44d92ac9f1e4725178ab0cefd9add8126"
[ -z "${DISTRO}" ] && export DISTRO="tegrademo"
[ -z "${BUILD_IMAGE}" ] && export BUILD_IMAGE="demo-image-full"
[ -z "${NVIDIA_DEVNET_MIRROR}" ] && export NVIDIA_DEVNET_MIRROR="file:///home/user/sdk_downloads"

# Installs the nVidia SDK
sdkmanager --cli install --staylogin true --product Jetson --version 4.5.1 \
    --targetos Linux --host true --target P3448-0003 --flash skip \
    --additionalsdk TensorFlow --select "Jetson OS" --select "Jetson SDK Components" \
    --license accept --datacollection disable --downloadfolder "/home/user/sdk_downloads" \
    --targetimagefolder "/home/user/nvidia/nvidia_sdk/" --sudopassword '\n'

# Clone L4T Yocto Base
YL4T_SUCCESS="false"
git clone https://github.com/OE4T/tegra-demo-distro.git ${CUR_DIR}/tegra-demo-distro
cd "${CUR_DIR}/tegra-demo-distro/" || echo "Could not enter L4T directory"
git checkout ${BRANCH}
git submodule update --init --recursive

# Clone AESD Final Project Layer & add it to L4T layer
git clone https://github.com/cu-ecen-5013/final-project-CalebProvost.git --branch yocto-layer layers/meta-aesd-final
. ./setup-env --machine ${MACHINE} --distro ${DISTRO}
bitbake-layers add-layer "${CUR_DIR}/tegra-demo-distro/layers/meta-aesd-final"

# Begin L4T Tegra Build
bitbake ${BUILD_IMAGE} && export YL4T_SUCCESS="true"

if [ "${YL4T_SUCCESS}" = "true" ]; then
    echo "Yocto Build of L4T Complete. Preping Image to flash to SD Card."
    mkdir -p "${CUR_DIR}/tegraflash"
    cd "${CUR_DIR}/tegraflash" || echo "Could Not Enter SD Card Staging Directory"
    cp "${CUR_DIR}/tegra-demo-distro/build/tmp/deploy/images/${MACHINE}/${BUILD_IMAGE}-${MACHINE}.tegraflash.tar.gz" "${CUR_DIR}/tegraflash/"
    tar -xf "${CUR_DIR}/tegra-demo-distro/build/tmp/deploy/images/${MACHINE}/${BUILD_IMAGE}-${MACHINE}.tegraflash.tar.gz"
    [ -f "../${BUILD_IMAGE}-${MACHINE}.img" ] && rm -rf "../${BUILD_IMAGE}-${MACHINE}.img"
    ./dosdcard.sh "../${BUILD_IMAGE}-${MACHINE}.img" && SDCARD_IMAGE="true"

    echo "" && echo ""
    echo "####################################################################################################"
    echo "Yocto has finished building the OE4T image \"${BUILD_IMAGE}\" for the \"${MACHINE}\"."
    echo "Deloyment files can be found here: ${CUR_DIR}/tegra-demo-distro/build/tmp/deploy/images/${MACHINE}/"
    if [ "${SDCARD_IMAGE}" = "true" ]; then
        echo ""
        echo "SD Card image for flashing can be found here: ${CUR_DIR}/${BUILD_IMAGE}-${MACHINE}.img"
    fi
    echo "####################################################################################################"
    echo ""
    exit 0

else
    echo "Could not determine the success of Yocto building L4T; exiting..."
    exit 1
fi
