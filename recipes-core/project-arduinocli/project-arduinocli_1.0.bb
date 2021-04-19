SUMMARY = "AESD Course Project Layer"
HOMEPAGE = "https://aesd-course-project.github.io/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://github.com/cu-ecen-5013/final-project-arpit6232.git;branch=arduino_cli;lfs=0"

PV = "1.0+git${SRCPV}"
SRCREV = "de0df98ee512797f6db414c4e8e539319c210a7d"

S = "${WORKDIR}/git"

inherit systemd
SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE_${PN} = "arduinocli.service"

SRC_URI_append = " file://arduinocli.service "

FILES_${PN} += "${systemd_unitdir}/system/arduinocli.service"
FILES_${PN} += "${bindir}/arduino-cli"
FILES_${PN} += "/home/root/cli.sh"

do_configure () {
	:
}

do_compile () {
	oe_runmake
}

do_install () {

    install -d ${D}${bindir}
    install -m 0777 ${S}/arduino-cli ${D}${bindir}/

    install -d ${D}/home/root
    install -m 0644 ${S}/cli.sh ${D}/home/root/cli.sh

    install -d ${D}/${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/arduinocli.service ${D}/${systemd_unitdir}/system
}

INSANE_SKIP_${PN} = "ldflags"
