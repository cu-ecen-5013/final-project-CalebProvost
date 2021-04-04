# From Scratch  

Its as easy as [building the docker image](#Build-the-Dockerized-Yocto-for-Jetson), [having docker build L4T](#Run-the-Docker-Container-to-Build-L4T-Image), and [flashing the SD Card](#Flash-the-SD-Card)!  
<sub>With the caviot that **_maybe_** you'll need to [install docker](#Install-Docker) if you don't already have it</sub>  

---

## Important Preamble

Ubuntu 18.04 on x86_64 system used as Host/Build system. Others not tested.  
As of the date of writing, version 4.3 does not support the 2GB version.  
A clarification as provided by nVidia:  
> A Jetson Nano 2GB Developer Kit includes a non-production specification Jetson module (P3448-0003) attached to a reference carrier board (P3542-0000).  
> This user guide covers two revisions of the developer kit:  
>
> * Part Number 945-13541-0000-000 including 802.11ac wireless adapter and cable  
> * Part Number 945-13541-0001-000 NOT including adapter and cable  

We are targeting to build for the module, which means the default was set to `P3448-0003`.  

---

## Install Docker  

---
See the latest installation method for your distro from Docker's website.  
The following was used to install on the **_host_** build system:  

* Install the package dependencies

    ```shell
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    ```

* Add Docker Keys  

    ```shell
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg`
    ```

* Add Docker's repository to the package manager

    ```shell
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    ```

* Install Docker

    ```shell
    sudo apt-get install docker.io
    ```

* Follow the [post-install steps for Docker](https://docs.docker.com/engine/install/linux-postinstall/). </br>
Most importantly, create a new group called docker and add your username to it. **Changes take affect upon logging in again (reboot)**: </br>
`sudo usermod -aG docker $USER && newgrp docker && su -l $USER`  

**_Optional_:** If you'd like to change the docker storage location to an external device, feel free to do the following:  

* Edit /etc/docker/daemon.json (if it doesn’t exist, create it) and include:

    ```json
    {
    "data-root": "/new/path/to/docker-data"
    }
    ```

* Then restart Docker with:

    ```bash
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    ```

## Build the Dockerized Yocto for Jetson

<sub>**Info:** Executing the `tegra_install_n_build.sh` outside of the Docker container will fail. It is a script which runs automatically by and inside the docker container itself.</sub>  

* Run the following to build the docker image with the default configuration:  
`docker build -t yocto-tegra:spring21 .`  

    If you'd like to override the default branch, machine, target distro, or other settings, you can do so by overwriting their values with the argument tag `--build-arg VAR=value`. Below is an example provided to demonstrate this. See the header inside `tegra_install_n_build.sh` for defaults and overwritable variables.  

    ```shell
    docker build -t yocto-tegra:spring21 --build-arg MACHINE=jetson-nano-2gb-devkit \
            --build-arg BRANCH=master --build-arg BUILD_IMAGE=demo-image-full \
            --build-arg DISTRO="tegrademo-mender build-tegrademo-mender" \
    ```

## Run the Docker Container to Build L4T Image  

Start the Docker container with the command below and it will kick off an installation of nVidia's SDK and build the L4T yocto image.  
You will be prompted to follow the link and log into the nVidia developer's account which will then validate the install.  
Note: The following example maps the build output directory to the directory where this Dockerfile is executed  

`docker run -it --rm -v $PWD:/home/aesd/ --name yl4t yocto-tegra:spring21`

<sub>**Hint:** You can remove the `--rm` flag from the above command to keep the container instance once it's complete and attach to it for your own modifications/build edits</sub>

## Flash the SD Card

The SD Card image is created using the L4T SD Card tools and placed in the root of this directory. It's default name will be "demo-image-full-jetson-nano-2gb-devkit.img" but will follow the following naming convention if the defaults were overwritten in the prior steps: `"${BUILD_IMAGE}-${MACHINE}.img"`  

Use your flavor of SD Card flashing tool (like balenaEtcher for Windows or `dd` for linux) and flash the provided image onto an SD card and insert into the Jetson nano to start having fun.  

Note: An SD Card sized ~16GB will be needed. We found that our image was 300MB too large and thus used a 32GB card instead.  
