EAPI=7

inherit git-r3

DESCRIPTION="Config and scripts mdev-like-a-boss"
HOMEPAGE="https://github.com/slashbeast/mdev-like-a-boss"
EGIT_REPO_URI="https://github.com/slashbeast/mdev-like-a-boss.git"
EGIT_COMMIT="${PV}"
KEYWORDS="~amd64 ~x86"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=sys-fs/mdev-bb-1.21.1"

src_install() {
	mkdir -p "${D}/etc" || die
	mv "${S}/mdev.conf" "${D}/etc/mdev.conf"

	newinitd "${S}/mdev.init" mdev || die
	rm -f "${S}/mdev.init"

	mkdir -p "${D}/opt/mdev" || die
	cp -a "${S}"/* "${D}/opt/mdev/" || die
}

pkg_postinst() {
	einfo
	einfo "Remember to add mdev to sysinit runlevel."
	einfo "   rc-update add mdev sysinit"
	einfo
	ewarn
	ewarn "Also remember to remove any udev* and devfs init scripts"
	ewarn "from all runlevels."
	ewarn
}
