EAPI=4

inherit git-2

DESCRIPTION="Config and scripts mdev-like-a-boss"
HOMEPAGE="https://github.com/slashbeast/mdev-like-a-boss"

EGIT_REPO_URI="git://github.com/slashbeast/mdev-like-a-boss.git"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
SLOT="0"
IUSE="+mdev-bb"

DEPEND=""
RDEPEND="${DEPEND}
	mdev-bb? ( sys-fs/mdev-bb )"

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
