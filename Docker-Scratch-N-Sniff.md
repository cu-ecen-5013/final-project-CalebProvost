
# From Scratch  

**<sub>Ubuntu 18.04 on x86_64 system used as Host/Build system. Others not tested.</sub>**  

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
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg`
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

* Follow the [post-install steps for Docker](https://docs.docker.com/engine/install/linux-postinstall/)  

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
---
Run the following for the default configuration:  
`docker build -t yocto-tegra:spring21 .`  

Note: If you'd like to override the default branch, machine, and target distro you can do so by appending their new values with the argument tag `--build-arg VAR=value` like the example provided below. For the list of defaults which can be overwritten, see `tegra_builder.sh`.  
<sub>Note: Executing the `tegra_builder.sh` outside of the Docker container will fail. To build the Tegra image, proceed to [Run the Docker Container](#Run-the-Docker-Container).</sub>  

```shell
docker build -t yocto-tegra:spring21 --build-arg MACHINE=jetson-nano-2gb-devkit \
        --build-arg BRANCH=master --build-arg BUILD_IMAGE=demo-image-full \
        --build-arg DISTRO="tegrademo-mender build-tegrademo-mender" \
```

## Install the SDK

Install the included .deb:  

`sudo apt-get install -y ./sdkmanager_1.4.1-7402_amd64.deb`

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

```shell
docker run -it --rm -v $PWD:/home/aesd/ yocto-tegra:spring21
```

## To Do

Provide Flash Tool instructions.
