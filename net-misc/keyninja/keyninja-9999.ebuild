inherit git

EAPI=4

DESCRIPTION=""
HOMEPAGE="https://github.com/slashbeast/keyninja"

EGIT_REPO_URI="https://github.com/slashbeast/keyninja.git"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=">=app-shells/bash-4.0.0"

src_install() {
	dobin "${S}/keyninja"
}
