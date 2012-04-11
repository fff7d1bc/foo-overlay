# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/e4rat/e4rat-0.2.1-r2.ebuild,v 1.1 2012/01/08 11:38:11 hwoarang Exp $

EAPI=4

inherit cmake-utils linux-info

DESCRIPTION="Toolset to accelerate the boot process and application startup"
HOMEPAGE="http://e4rat.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}_src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl
	>=dev-libs/boost-1.42
	sys-fs/e2fsprogs
	sys-process/audit"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~AUDITSYSCALL"

PATCHES=(
	"${FILESDIR}"/${PN}-shared-build.patch
	"${FILESDIR}"/${PN}-libdir.patch
)

pkg_setup() {
	check_extra_config
}

src_prepare() {
	base_src_prepare
	cp "${FILESDIR}/e4rat-preload-lite.c" "$S"
}


src_compile() {
	cd "$S"
	gcc -std=c99 -Wall -O2 -o e4rat-preload-lite e4rat-preload-lite.c

	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	# relocate binaries to /sbin. If someone knows of a better way to do it
	# please do tell me
	dodir sbin
	find "${D}"/usr/sbin -type f -exec mv {} "${D}"/sbin/. \; \
		|| die
	cp "${S}/e4rat-preload-lite" "${D}/sbin"
}

pkg_postinst() {
	elog
	elog "Please consult the upstream wiki if you need help"
	elog "configuring your system"
	elog "http://e4rat.sourceforge.net/wiki/index.php/Main_Page"
	elog
	if has_version sys-apps/preload; then
		elog "It appears you have sys-apps/preload installed. This may"
		elog "has negative effects on ${PN}. You may want to disable preload"
		elog "when using ${PN}."
		elog "http://e4rat.sourceforge.net/wiki/index.php/Main_Page#Debian.2FUbuntu"
	fi
}
