EAPI=4

inherit rpm multilib

DESCRIPTION="Brother DCP-J315W LPR+cupswrapper drivers"
HOMEPAGE="http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_prn.html#DCP-J315W"
SRC_URI="http://pub.brother.com/pub/com/bsc/linux/dlf/dcpj315wlpr-1.1.1-1.i386.rpm
		http://pub.brother.com/pub/com/bsc/linux/dlf/dcpj315wcupswrapper-1.1.1-3.i386.rpm"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="fetch strip"

DEPEND="net-print/cups
		app-text/a2ps"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

pkg_nofetch() {
	ewarn "Go to ${HOMEPAGE}"
	ewarn "Download ${A} to ${DISTDIR}"
}

src_unpack() {
	rpm_unpack ${A}
}

src_install() {
	has_multilib_profile && ABI=x86

	mkdir -p ${D}/opt/Brother || die
	cp -r ${WORKDIR}/usr/local/Brother/* ${D}/opt/Brother/ || die

	mkdir -p ${D}/usr/libexec/cups/filter || die
	( cd ${D}/usr/libexec/cups/filter/ && ln -s ../../../../opt/Brother/Printer/dcpj315w/lpd/filterdcpj315w brlpdwrapperdcpj315w ) || die
	mkdir -p ${D}/usr/local || die
	( cd ${D}/usr/local && ln -s ../../opt/Brother Brother ) || die
	mkdir -p ${D}/usr/share/cups/model || die
	( cd ${D}/usr/share/cups/model && ln -s ../../../../opt/Brother/Printer/dcpj315w/cupswrapper/brdcpj315w.ppd ) || die


}
