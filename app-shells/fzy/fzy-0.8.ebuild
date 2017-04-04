EAPI="5"

DESCRIPTION=" A better fuzzy finder, dmenu-like solution for cli"
HOMEPAGE="https://github.com/jhawthorn/fzy"
SRC_URI="https://github.com/jhawthorn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake PREFIX="${D}/usr" install
}
