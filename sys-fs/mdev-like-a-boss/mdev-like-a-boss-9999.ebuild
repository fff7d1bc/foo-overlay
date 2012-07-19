EAPI=4

inherit git-2

DESCRIPTION="Config and scripts mdev-like-a-boss"
HOMEPAGE="https://github.com/slashbeast/mdev-like-a-boss"

EGIT_REPO_URI="git://github.com/slashbeast/mdev-like-a-boss.git"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	mkdir -p "${D}/opt/mdev" || die
	cp -a "${S}"/* "${D}/opt/mdev/" || die
}

