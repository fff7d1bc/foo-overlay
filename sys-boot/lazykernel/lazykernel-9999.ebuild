EAPI="5"

inherit git-2

DESCRIPTION=""
HOMEPAGE="https://github.com/slashbeast/lazykernel"

EGIT_REPO_URI="https://github.com/slashbeast/lazykernel.git"
KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	mkdir -p "${D}/etc" "${D}/sbin"

	cp lazykernel "${D}/sbin/lazykernel"
	chmod 700 "${D}/sbin/lazykernel"

	cp lazykernel.conf.sample "${D}/etc/lazykernel.conf"

	dodoc README.rst
}

