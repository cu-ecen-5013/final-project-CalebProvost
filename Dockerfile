# Dockerized Arduino CLI. For more info see https://arduino.github.io/arduino-cli/latest/
FROM calebprovost/arduino-cli:latest

# Configure Arduino CLI
RUN arduino-cli config init && \
    # https://arduino.github.io/arduino-cli/latest/getting-started/#connect-the-board-to-your-pc
    arduino-cli core update-index && \
    arduino-cli board list --format json

RUN arduino-cli core install arduino:mbed && \
    arduino-cli config set library.enable_unsafe_install true && \
    arduino-cli lib install "Arduino_TensorFlowLite@2.4.0-ALPHA" \
        "Harvard_TinyMLx@1.0.1-Alpha" \
        "Arduino_LSM9DS1@1.1.0" \
        "ArduinoBLE@1.1.3"  && \
    arduino-cli lib list

CMD [ "arduino-cli" ]
