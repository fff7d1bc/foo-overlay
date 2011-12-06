# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils

DESCRIPTION="Toolset to accelerate the boot process and application startup"
HOMEPAGE="http://e4rat.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}_src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl
	>=dev-libs/boost-1.42[static-libs]
	sys-fs/e2fsprogs
	sys-process/audit"

RDEPEND="${DEPEND}"

src_configure() {
	# e4rat provides crucial binaries that should go directly into /sbin
	# also all documentation mentions /sbin/e4rat-preload etc.
	mycmakeargs=(
		"-DCMAKE_INSTALL_PREFIX=/"
	)
	cmake-utils_src_configure
}

src_prepare() {
	cp "${FILESDIR}/e4rat-preload-lite.c" "$S"
}

src_compile() {
	einfo ASD
	cd "$S"
	gcc -std=c99 -Wall -O2 -o e4rat-preload-lite e4rat-preload-lite.c

	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	cp "${S}/e4rat-preload-lite" "${D}/sbin"
}

pkg_postinst() {
	echo
	einfo
	einfo "e4rat need CONFIG_AUDITSYSCALL=y in kernel."
	einfo
	echo
}



