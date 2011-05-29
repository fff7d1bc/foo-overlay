# Distributed under the terms of the GNU General Public License v2

EAPI=4
if [ "$PV" = 9999 ]; then
	inherit git
	EGIT_REPO_URI="https://github.com/nelhage/reptyr.git"
	KEYWORDS=""
else
	github_user="nelhage"
	github_tag="$PN-$PV"
	SRC_URI="https://github.com/${github_user}/${PN}/tarball/${github_tag} -> ${PN}-git-${PV}.tgz"
	KEYWORDS="~x86 ~amd64"
fi
DESCRIPTION="Reparent a running program to a new terminal."
HOMEPAGE=""

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

if [ "$PV" != '9999' ]; then
	src_unpack() {
		unpack ${A} || die
		mv "${WORKDIR}/${github_user}-${PN}"-??????? "${S}"
	}
fi

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	make DESTDIR="${D}" PREFIX="/usr" install
}
