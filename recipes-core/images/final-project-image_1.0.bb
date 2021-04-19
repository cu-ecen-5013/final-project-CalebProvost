IMAGE_FEATURES += "ssh-server-openssh"

LICENSE = "MIT"

inherit core-image

CORE_IMAGE_BASE_INSTALL += "packagegroup-demo-base packagegroup-demo-basetests"
CORE_IMAGE_BASE_INSTALL += "${@'packagegroup-demo-systemd' if d.getVar('VIRTUAL-RUNTIME_init_manager') == 'systemd' else ''}"

inherit nopackages
DESCRIPTION = "Full Tegra demo image with X11/Sato, nvidia-docker, OpenCV, \
and Tegra multimedia API sample apps."

IMAGE_FEATURES += "splash x11-base x11-sato hwcodecs"

inherit features_check

REQUIRED_DISTRO_FEATURES = "x11 opengl virtualization"

CORE_IMAGE_BASE_INSTALL += "packagegroup-demo-x11tests"
CORE_IMAGE_BASE_INSTALL += "${@bb.utils.contains('DISTRO_FEATURES', 'vulkan', 'packagegroup-demo-vulkantests', '', d)}"
CORE_IMAGE_BASE_INSTALL += "libvisionworks-devso-symlink nvidia-docker cuda-libraries tegra-mmapi-samples"

# CORE_IMAGE_BASE_INSTALL += "projct-server project-arduinocli"
IMAGE_INSTALL_append_tegra = " project-server project-arduinocli"
