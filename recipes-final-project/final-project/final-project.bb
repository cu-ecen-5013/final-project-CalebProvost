SUMMARY = "AESD Course Project Layer"
HOMEPAGE = "https://aesd-course-project.github.io/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
SRC_URI[sha256sum] = "8287a34b7102d8a9db383cc0eefcf971b5e9b1de7d695be710980da6a94b5087"

SRC_URI = "git://github.com/cu-ecen-5013/final-project-ZachTurner07.git;branch=develop;lfs=0"
SRCREV = "c138d56fa821d7720c764efea2d3caf9a17ad256"
PV = "1.0+git${SRCPV}"
S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "(tegra)"

FILES_${PN} += "uartserver"
TARGET_LDFLAGS += "-lrt -lpthread -pedantic -pthread"

do_configure () {
	:
}

do_compile () {
	oe_runmake
}

# TODO: Uncomment and adjust when init-scripts are finished
# inherit update-rc.d
# INITSCRIPT_PACKAGES = "${PN}"
# INITSCRIPT_NAME_${PN} = "uartserver-start-stop"

# TODO: Uncomment and adjust when init-scripts are finished
# do_install () {
#     install -d ${D}${bindir}
#     install -m 0755 ${S}/uartserver ${D}${bindir}/
#     install -d ${D}${sysconfdir}/init.d/
#     install -m 0755 ${S}/uartserver-start-stop ${D}${sysconfdir}/init.d/
# }
# TODO: Remove for adjusted version above
do_install () {
    install -d ${D}${bindir}
    install -m 0755 ${S}/uartserver ${D}${bindir}/
}
