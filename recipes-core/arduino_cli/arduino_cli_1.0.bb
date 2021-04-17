SUMMARY = "AESD Course Project Layer"
HOMEPAGE = "https://aesd-course-project.github.io/"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git@github.com:cu-ecen-5013/final-project-arpit6232.git;protocol=ssh;branch=main"

PV = "1.0+git${SRCPV}"
# set to reference a specific commit hash in arpit6232 repo
SRCREV = "243ad93561bd8f631c50eb29449e8a5c5f6773a3"

# This sets your staging directory based on WORKDIR, where WORKDIR is defined at 
# https://www.yoctoproject.org/docs/latest/ref-manual/ref-manual.html#var-WORKDIR
S = "${WORKDIR}/git"

do_configure () {
	:
}

do_compile () {
	oe_runmake
}

FILES_${PN} += "${ROOT_HOME}/arduino-cli"
FILES_${PN} += "${ROOT_HOME}/LICENSE.txt"
FILES_${PN} += "${bindir}/arduino-cli"

do_install () {
    install -d ${D}${bindir}
    install -m 0777 ${S}/arduino-cli ${D}${bindir}/

    install -d ${ROOT_HOME}
    install -m 0777 ${S}/arduino-cli ${ROOT_HOME}/
    install -m 0777 ${S}/LICENSE.txt ${ROOT_HOME}/
}
