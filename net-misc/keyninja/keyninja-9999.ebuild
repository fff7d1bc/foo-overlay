EAPI="5"
inherit git-2

DESCRIPTION="Damn lightweight solution to share one ssh-agent between shells."
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
