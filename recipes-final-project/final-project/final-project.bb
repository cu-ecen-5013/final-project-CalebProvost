SUMMARY = "AESD Course Project Layer"
HOMEPAGE = "https://aesd-course-project.github.io/"
LICENSE = "MIT"

COMPATIBLE_MACHINE = "(tegra)"

SRC_URI = "https://github.com/cu-ecen-5013/final-project-ZachTurner07.git;protocol=http;branch=develop"

PV = "1.0+git${SRCPV}"
SRCREV = "c138d56fa821d7720c764efea2d3caf9a17ad256"

S = "${WORKDIR}/git"

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
