EAPI=4

inherit autotools

DESCRIPTION="Dell laptop fan regulator for Linux/Solaris."
HOMEPAGE="http://dellfand.dinglisch.net/"
SRC_URI="http://dellfand.dinglisch.net/dellfand-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"


src_prepare() {
	epatch "${FILESDIR}/dellfand-include-fix.patch" || die
}

src_compile() {
	emake || die
}

src_install() {
	dosbin dellfand
	newinitd "${FILESDIR}/dellfand.init" dellfand
	newconfd "${FILESDIR}/dellfand.confd" dellfand
}
