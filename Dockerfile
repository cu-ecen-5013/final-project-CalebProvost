# AESD Course Project 1-run script
# Do not run till ready!
FROM calebprovost/arduino-cli:latest

RUN echo "Not yet ready" && exit 1

ARG INSTALL_DIR="\home"
ARG ARDUINO_VERSION="1.8.10"
ARG PORT="/dev/ttyACM0"
ARG BOARD_NAME="Arduino Nano 33 BLE"
ARG FQBN="arduino:mbed:nano33ble"
ARG ARDUINO_CORE="arduino:mbed"
ARG ARDUINO_CODE_DIR="/root/Arduino/libraries/arduino-library/examples/person_detection"
ARG DEV_LOC="/dev/serial/by-id/usb-Arduino_Nano_33_BLE_AD986F55B90290BE-if00"
ARG ARDUINO_IDE_EXE="./$INSTALL_DIR/bin/arduino-cli"


# Setup the core, library and the cli
RUN echo "Setting up arduino:mbed core and setting up config"
RUN arduino-cli core install ${ARDUINO_CORE}
RUN arduino-cli config init
RUN arduino-cli config set library.enable_unsafe_install true

# Libraries Install
RUN echo "Installing Libraries"
RUN arduino-cli lib install "Arduino_TensorFlowLite@2.4.0-ALPHA"
RUN arduino-cli lib install "Arduino_LSM9DS1@1.1.0"
RUN arduino-cli lib install "ArduinoBLE@1.1.3"

# Compile code
RUN echo "Compiling Person Detection Code"
RUN arduino-cli compile -b ${FQBN} ${ARDUINO_CODE_DIR} -v

# RUN sudo arduino-cli upload -b arduino:mbed:nano33ble -p ${PORT} /root/Arduino/libraries/arduino-library/examples/person_detection -v

# TODO: Validate installation of Arduino code

FROM calebprovost/dockter-l4t:sdk_installed

COPY ./build.sh ./
RUN ./build.sh
