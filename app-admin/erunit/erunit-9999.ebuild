EAPI="7"
inherit git-r3

DESCRIPTION="Root-less wrapper around runit."
HOMEPAGE="https://github.com/slashbeast/erunit"

EGIT_REPO_URI="https://github.com/slashbeast/erunit.git"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	>=app-shells/bash-4.0.0
	sys-process/runit
"

src_install() {
	dobin "${S}/erunit"
}
