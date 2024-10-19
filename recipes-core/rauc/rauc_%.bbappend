FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append := "  \
	file://pre-install-handler.sh \
	file://calc-root-hash.sh \
"

RDEPENDS:${PN} += "bash"

do_install:prepend() {
	# Add handler section to system.conf:
	if grep -qi '^\[handlers\]' ${WORKDIR}/system.conf; then
		bberror "RAUC's system.conf already has a [handlers] section; install task needs review."
	fi
	echo -e '\n[handlers]\npre-install=${bindir}/pre-install-handler.sh' >> ${WORKDIR}/system.conf
}

do_install:append() {
	install -d ${D}${bindir}
	install -m 755 ${WORKDIR}/pre-install-handler.sh ${D}${bindir}/
	install -m 755 ${WORKDIR}/calc-root-hash.sh ${D}${bindir}/
}
