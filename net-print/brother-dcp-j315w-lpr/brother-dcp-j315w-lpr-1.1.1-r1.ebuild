EAPI=4

inherit rpm

DESCRIPTION="Brother DCP-J315W LPR driver"
HOMEPAGE="http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_prn.html#DCP-J315W"
SRC_URI="http://pub.brother.com/pub/com/bsc/linux/dlf/dcpj315wlpr-1.1.1-1.i386.rpm"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="fetch strip"

DEPEND=""
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
	cp -r $WORKDIR $D
	mv $D/work/* $D
	rm -r $D/work/

	mkdir -p ${D}/usr/libexec/cups/filter || die
	( cd ${D}/usr/libexec/cups/filter/ && ln -s ../../../../usr/local/Brother/Printer/dcpj315w/lpd/filterdcpj315w brlpdwrapperdcpj315w )
}
