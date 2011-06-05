EAPI='4'

EGIT_REPO_URI="git://github.com/mkottman/acpi_call.git"

inherit git linux-info linux-mod

DESCRIPTION="A kernel module that enables you to call ACPI methods"
HOMEPAGE="http://github.com/mkottman/acpi_call"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+scripts"

CONFIG_CHECK="ACPI"
MODULE_NAMES="acpi_call(misc:${S})"
BUILD_TARGETS="clean default"

src_compile() {
	BUILD_PARAMS="KDIR=${KV_OUT_DIR} M=${S}"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	mkdir "${D}/usr/share/${PN}" -p
	cp "${S}/README" "${D}/usr/share/${PN}"
	ecompress --queue "${D}/usr/share/${PN}/README"

	if use scripts; then
		cp ${S}/*.sh "${D}/usr/share/${PN}"
	fi
}

pkg_postinst() {
	linux-mod_pkg_postinst

	if use scripts; then
		echo
		einfo
		einfo "Scripts shipped with acpi_call was installed into '/usr/share/${PN}'."
		einfo
		echo
	fi
}
