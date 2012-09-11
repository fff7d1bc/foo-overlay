EAPI="4"

inherit eutils

DESCRIPTION="mdf to iso converter"
HOMEPAGE="http://mdf2iso.berlios.de/"
SRC_URI="http://download.berlios.de/${PN}/${P}-src.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch ${FILESDIR}/${P}-bigfiles.patch
}

src_install() {
	mkdir -p "${D}/usr/bin"
	cp "${S}/src/mdf2iso" "${D}/usr/bin"	
}
