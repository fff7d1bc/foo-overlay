EAPI=3

inherit git-2 cmake-utils

DESCRIPTION="bbcp is a point-to-point network file copy application written by Andy Hanushevsky at SLAC as a tool for the BaBar collaboration. It is capable of transferring files at approaching line speeds in the WAN."
HOMEPAGE="https://www.slac.stanford.edu/~abh/bbcp/"
EGIT_REPO_URI="https://bitbucket.org/piotrkarbowski/bbcp.git"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	dev-libs/openssl
	sys-libs/zlib

"
RDEPEND="${DEPEND}"

src_install() {
	mkdir -p "${D}/usr/bin"
	cp "${CMAKE_BUILD_DIR}/bin/bbcp" "${D}/usr/bin/bbcp"
}
