# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit x-modular flag-o-matic

DESCRIPTION="X.Org Xft library"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="+cleartype ubuntu"

RDEPEND="x11-libs/libXrender
	x11-libs/libX11
	x11-libs/libXext
	x11-proto/xproto
	>=media-libs/fontconfig-2.2[ubuntu=,cleartype=]
	media-libs/freetype[ubuntu=,cleartype=]"

DEPEND="${RDEPEND}"

pkg_setup() {
	# No such function yet
	# x-modular_pkg_setup

	# (#125465) Broken with Bdirect support
	filter-flags -Wl,-Bdirect
	filter-ldflags -Bdirect
	filter-ldflags -Wl,-Bdirect

	if use cleartype && use ubuntu; then
		eerror "The cleartype and ubuntu useflags are mutually exclusive,"
		eerror "you must disable one of them."
		die "Either disable the cleartype or the ubuntu useflag."
	fi
}
src_prepare() {
	if use ubuntu; then
		epatch "${FILESDIR}"/${P}-ubuntu.patch
	fi
}

pkg_postinst() {
	echo
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	ewarn "See http://forums.gentoo.org/viewtopic-t-511382.html for support topic on Gentoo forums."
	echo
}
