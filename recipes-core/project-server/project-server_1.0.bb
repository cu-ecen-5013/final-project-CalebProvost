SUMMARY = "AESD Course Project Layer"
HOMEPAGE = "https://aesd-course-project.github.io/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://github.com/cu-ecen-5013/final-project-ZachTurner07.git;branch=develop;lfs=0"
SRCREV = "${AUTOREV}"
PV = "1.0+git${SRCPV}"
S = "${WORKDIR}/git"

do_configure () {
	:
}

do_compile () {
	oe_runmake
}

# Preserve working install method
# do_install () {
#     install -d ${D}${bindir}
#     install -m 0755 ${S}/uartserver ${D}${bindir}/
# }

inherit systemd
SYSTEMD_AUTO_ENABLE = "enable"

do_install() {
    install -d ${D}${bindir} ${D}${systemd_system_unitdir}/
    install -m 0755 ${S}/uartserver ${D}${bindir}/
    install -m 0644 ${S}/uartserver.service ${D}${systemd_unitdir}/system/
}

FILES_${PN} += "\
    ${bindir}/uartserver \
    ${systemd_unitdir}/uartserver.service \
    "

SYSTEMD_SERVICE_${PN} = "uartserver.service"
