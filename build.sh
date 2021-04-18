#!/bin/bash

# Set Defaults if not provided
CUR_DIR=$(pwd)
# For Yocto Build
export MACHINE="jetson-nano-2gb-devkit"
export BRANCH="master"
export DISTRO="final-project"
export BUILD_IMAGE="final-project-image"
export NVIDIA_DEVNET_MIRROR="file:///home/user/sdk_downloads"

# Clone L4T Yocto Base
YL4T_SUCCESS="false"
git clone https://github.com/OE4T/tegra-demo-distro.git ${CUR_DIR}/tegra-demo-distro
cd "${CUR_DIR}/tegra-demo-distro/" || echo "Could not enter L4T directory"
git checkout ${BRANCH}
git submodule update --init --recursive

# Clone AESD Final Project Layer & add it to L4T layer
git clone https://github.com/cu-ecen-5013/final-project-CalebProvost.git --branch=yocto-layer --single-branch layers/meta-final-project
. ./setup-env --machine ${MACHINE} --distro ${DISTRO}

# Begin L4T Tegra Build
bitbake ${BUILD_IMAGE} && export YL4T_SUCCESS="true"

if [ "${YL4T_SUCCESS}" = "true" ]; then
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
    else
        echo "Yocto Build of OE4T Complete. SD Card Image creation has failed and is known to do so within Docker."
        echo "Follow the steps echo'ed below to try again (externally from docker)"
        echo 'mkdir -p "$PWD/tegraflash" && cd "$PWD/tegraflash"'
        echo 'cp "$PWD/tegra-demo-distro/build/tmp/deploy/images/${MACHINE}/${BUILD_IMAGE}-${MACHINE}.tegraflash.tar.gz" .'
        echo 'tar -xf "$PWD/tegra-demo-distro/build/tmp/deploy/images/${MACHINE}/${BUILD_IMAGE}-${MACHINE}.tegraflash.tar.gz"'
        echo './dosdcard.sh "../${BUILD_IMAGE}-${MACHINE}.img"'
    fi
    echo "####################################################################################################"
    echo ""
    exit 0

else
    echo "Could not determine the success of Yocto building L4T; exiting..."
    exit 1
fi
