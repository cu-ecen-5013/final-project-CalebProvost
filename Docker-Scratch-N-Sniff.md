# From Scratch  

**<sub>Ubuntu 18.04 on x86_64 system used as Host/Build system. Others not tested.</sub>**  

## Install Docker  

`sudo apt-get install docker.io`  

### Follow the [post-install steps for Docker](https://docs.docker.com/engine/install/linux-postinstall/)  

Optional:
If you'd like to change the docker storage location to an external device, feel free to do the following:

Edit /etc/docker/daemon.json (if it doesn’t exist, create it) and include:

```json
{
  "data-root": "/new/path/to/docker-data"
}
```

Then restart Docker with:

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## Build Docker Image

Run the following for the default configuration:  
`docker build -t yocto-tegra:spring21 .`  

Note: If you'd like to override the default branch, machine, and target distro you can do so by appending their new values with the argument tag `--build-arg VAR=value`. See `tegra_builder.sh` for overwrite-able variables.  

```xterm
docker build -t yocto-tegra:spring21 --build-arg MACHINE=jetson-nano-2gb-devkit \
        --build-arg BRANCH=master --build-arg BUILD_IMAGE=demo-image-full \
        --build-arg DISTRO="tegrademo-mender build-tegrademo-mender" \
```

## Load the SDK Manager Docker

Load the Dockerized SDK:

```xterm
docker load -i ./sdkmanager_[version].[build#]_docker.tar.gz 
docker tag sdkmanager:[version].[build#] sdkmanager:latest 
```

## Install the SDK

Modify `sdkinstall_jetson_response.ini` to meet your needs and run the following command to install the SDK:  
`docker run --rm -it --privileged -v /dev/bus/usb:/dev/bus/usb/ sdkmanager --cli install --responsefile sdkinstall_jetson_response.ini`

If the above response files method doesn't work for you (didn't for me), you can enter them via the command line like so:
```xterm
docker run --rm -it --privileged -v /dev/bus/usb:/dev/bus/usb/ sdkmanager --cli install \
    --logintype devzone --staylogin true --product Jetson --version 4.5.1 --targetos Linux \
    --host true --target P3448-0003 --flash all --additionalsdk TensorFlow \
    --select "Jetson OS" --select "Jetson SDK Components" --license accept \
    --datacollection disable --downloadfolder /media/aesd/yocto/sdk_downloads \
    --targetimagefolder /media/aesd/yocto/nvidia/nvidia_sdk/
```
You will be given a link to follow in order to log into your account. After you do so, the CLI prompt should continue and provide you with some clues if it failed to install.  

<sub>Note: As of the date of writing, version 4.3 does not support the 2GB version listed above. Prior 4GB models may have success; our 2GB models did no.</sub>

**! Important clarification as provided by nVidia:**
> A Jetson Nano 2GB Developer Kit includes a non-production specification Jetson module (P3448-0003) attached to a reference carrier board (P3542-0000).  
> This user guide covers two revisions of the developer kit:  
>
> * Part Number 945-13541-0000-000 including 802.11ac wireless adapter and cable  
> * Part Number 945-13541-0001-000 NOT including adapter and cable  

We are targeting to build for the module, which means we use `P3448-0003` during our target selection.  

## Run the Docker Container  

Note: The following example maps the build output directory to the directory where this Dockerfile is executed  

```xterm
docker run -it --rm -v $PWD:/home/aesd/ yocto-tegra:spring21
```

## To Do

Provide Flash Tool instructions.
