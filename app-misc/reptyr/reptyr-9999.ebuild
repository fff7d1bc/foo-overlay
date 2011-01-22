# Distributed under the terms of the GNU General Public License v2

EAPI=3

inherit git

DESCRIPTION="Reparent a running program to a new terminal —"
HOMEPAGE=""
EGIT_REPO_URI="https://github.com/nelhage/reptyr.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"


src_install() {
	dobin reptyr
	dodoc README NOTES COPYING
}
