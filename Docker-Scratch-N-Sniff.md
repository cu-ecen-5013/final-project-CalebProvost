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

`docker build -t yocto-tegra:spring21 .`  

Note: If you'd like to override the default branch, machine, and target distro you can do so by appending their new values with the argument tag `--build-arg VAR=value`. See `tegra_builder.sh` for overwrite-able variables.  

```bash
docker build -t yocto-tegra:spring21 --build-arg MACHINE=jetson-nano-2gb-devkit \
        --build-arg BRANCH=gatesgarth --build-arg BUILD_IMAGE=demo-image-full \
        --build-arg DISTRO="tegrademo-mender build-tegrademo-mender" \
```

## Create Docker Container  

Note: The following example maps the build output directory to the directory where this Dockerfile is executed  

```bash
docker run -it --rm -v $PWD:/home/aesd/ yocto-tegra:spring21
```

## To Do

Provide Flash Tool instructions.
