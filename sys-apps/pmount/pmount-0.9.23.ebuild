# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pmount/pmount-0.9.23.ebuild,v 1.3 2010/06/26 14:58:43 armin76 Exp $

EAPI=2
inherit base eutils

DESCRIPTION="Policy based mounter that gives the ability to mount removable devices as a user"
HOMEPAGE="http://pmount.alioth.debian.org/"
SRC_URI="http://dev.gentoo.org/~ssuominen/${P}.tar.bz2"
#SRC_URI="https://alioth.debian.org/frs/download.php/3310/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~ppc ~ppc64 sh sparc x86"
IUSE="crypt"

RDEPEND=">=sys-apps/util-linux-2.16
	crypt? ( >=sys-fs/cryptsetup-1.0.5 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext"

PATCHES=( "${FILESDIR}/${PN}-0.9.19-testsuite-missing-dir.patch" "${FILESDIR}/pmount-flush-mount-opt-0.9.22.patch" )

pkg_setup() {
	enewgroup plugdev
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-hal
}

src_test() {
	local testdir=${S}/tests/check_fstab

	ln -s $testdir/a $testdir/b && ln -s $testdir/d $testdir/c && \
		ln -s $testdir/c $testdir/e \
		|| die "Unable to create fake symlinks required for testsuite"
	emake check || die
}

src_install () {
	# Must be run SETUID+SETGID, bug #250106
	exeinto /usr/bin
	exeopts -m 6710 -g plugdev
	doexe src/pmount src/pumount || die

	dodoc AUTHORS ChangeLog TODO || die
	doman man/pmount.1 man/pumount.1 || die

	insinto /etc
	doins etc/pmount.allow || die
}

pkg_postinst() {
	elog
	elog "This package has been installed setuid and setgid."

	elog "The permissions are as such that only users that belong to the plugdev"
	elog "group are allowed to run this. But if a script run by root mounts a"
	elog "device, members of the plugdev group will have access to it."
	elog
	elog "Please add your user to the plugdev group to be able to mount USB drives"
}
