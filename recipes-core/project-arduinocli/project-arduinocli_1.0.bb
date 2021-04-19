SUMMARY = "AESD Course Project Layer"
HOMEPAGE = "https://aesd-course-project.github.io/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://github.com/cu-ecen-5013/final-project-arpit6232.git;branch=arduino_cli;lfs=0"

PV = "1.0+git${SRCPV}"
SRCREV = "d6969b288c7716d8c6851136d9a0d3d0ef333b6a"

S = "${WORKDIR}/git"

do_configure () {
	:
}

do_compile () {
	oe_runmake
}

do_install () {
    install -d ${D}${bindir}
    install -m 0777 ${S}/arduino-cli ${D}${bindir}/

    install -d ${D}${bindir}
    install -m 0777 ${S}/cli.sh ${D}${bindir}/
}

FILES_${PN} += "${bindir}/arduino-cli"
FILES_${PN} += "/home/cli.sh"

INSANE_SKIP_${PN} = "ldflags"
