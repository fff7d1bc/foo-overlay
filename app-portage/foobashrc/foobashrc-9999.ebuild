EAPI="5"

inherit git-2

DESCRIPTION=""
HOMEPAGE="https://github.com/slashbeast/foobashrc"

EGIT_REPO_URI="https://github.com/slashbeast/foobashrc.git"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	mkdir -p "${D}/etc/portage" || die
	cp "${S}/bashrc" "${D}/etc/portage/foobashrc.bashrc" || die
}

pkg_postinst() {
	echo
	einfo
	einfo "In order to enable foobashrc go to /etc/portage and do:"
	einfo "ln -s foobashrc.bashrc bashrc"
	einfo
	echo
}

