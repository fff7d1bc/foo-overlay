# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/rtorrent/rtorrent-0.8.6.ebuild,v 1.2 2009/12/28 20:35:30 armin76 Exp $

EAPI=2

inherit eutils

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
SRC_URI="http://libtorrent.rakshasa.no/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="daemon debug ipv6 xmlrpc +colors"

COMMON_DEPEND=">=net-libs/libtorrent-0.12.${PV##*.}
	>=dev-libs/libsigc++-2.2.2:2
	>=net-misc/curl-7.19.1
	sys-libs/ncurses
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	daemon? ( app-misc/screen )"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"

src_prepare() {
	if use colors ; then
		epatch "${FILESDIR}/rtorrent-0.8.6-canvas-fix.patch"
	fi
}

pkg_postinst() {
	if use colors ; then
		echo
		einfo "rtorrent colors patch"
		einfo "Set colors using the options below in .rtorrent.rc:"
		einfo "Options: done_fg_color, done_bg_color, active_fg_color, active_bg_color"
		einfo "Colors: 0 = black, 1 = red, 2 = green, 3 = yellow, 4 = blue, 5 = magenta, 6 = cyan and 7 = white"
		einfo "Example: done_fg_color = 1"
		echo
	fi
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_with xmlrpc xmlrpc-c)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README TODO doc/rtorrent.rc

	if use daemon; then
		newinitd "${FILESDIR}/rtorrentd.init" rtorrentd || die "newinitd failed"
		newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd || die "newconfd failed"
	fi
}
