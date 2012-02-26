EAPI=3

DESCRIPTION="Crux's utilities to manage software packages."
HOMEPAGE="http://crux.nu/"

if [ "$PV" = 9999 ]; then
	inherit git-2
	EGIT_REPO_URI="git://crux.nu/tools/pkgutils.git"
	KEYWORDS=""
else
	SRC_URI="http://crux.nu/files/$PN-$PV.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="app-arch/xz-utils[static-libs]
		app-arch/libarchive[static-libs]"
RDEPEND=""

src_prepare() {
	# Does not install man pages by make install.
	sed '/^[[:space:]]install.*MANDIR/d' ${S}/Makefile -i || die
}

src_install() {
	make DESTDIR="${D}" install || die
	doman ${S}/*.8
}
