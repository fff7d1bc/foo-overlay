EAPI=4

inherit rpm multilib eutils

DESCRIPTION="Brother DCP-J315W cups wrapper driver"
HOMEPAGE="http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_prn.html#DCP-J315W"
SRC_URI="http://pub.brother.com/pub/com/bsc/linux/dlf/dcpj315wcupswrapper-1.1.1-3.i386.rpm"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="fetch strip"

DEPEND="net-print/cups
		app-text/a2ps
		net-print/brother-dcp-j315w-lpr"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

pkg_nofetch() {
	ewarn "Go to ${HOMEPAGE}"
	ewarn "Download ${A} to ${DISTDIR}"
}

src_unpack() {
	rpm_unpack
}

src_install() {
	has_multilib_profile && ABI=x86
	INSTDIR="/opt/Brother"

	dodir "${INSTDIR}/cupswrapper"
	mkdir -p ${D}/usr/share/cups/model || die
	mv ${S}/usr/local/Brother/Printer/dcpj315w/cupswrapper/brdcpj315w.ppd ${D}/usr/share/cups/model/brdcpj315w.ppd || die
	mv ${S}/usr/local/Brother/Printer/dcpj315w/cupswrapper/* "${D}${INSTDIR}/cupswrapper" || die
}
