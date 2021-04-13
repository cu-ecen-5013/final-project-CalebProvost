SUMMARY = "AESD Course Project Layer"
HOMEPAGE = "https://aesd-course-project.github.io/"
LICENSE = "MIT"

SRC_URI = "https://github.com/cu-ecen-5013/final-project-ZachTurner07.git;protocol=http;branch=develop"

PV = "1.0+git${SRCPV}"
SRCREV = "bb18ccaaa1cf49a65771a0157508cdfe86d34980"

S = "${WORKDIR}/git"

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

FILES_${PN} += "${bindir}/uartserver"
