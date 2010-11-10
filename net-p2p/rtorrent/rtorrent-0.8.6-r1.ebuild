# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/rtorrent/rtorrent-0.8.6-r1.ebuild,v 1.7 2010/08/18 04:39:57 jer Exp $

EAPI=2

inherit eutils

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
SRC_URI="http://libtorrent.rakshasa.no/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="daemon debug ipv6 xmlrpc +bad_peer_handling"

COMMON_DEPEND=">=net-libs/libtorrent-0.12.${PV##*.}
	>=dev-libs/libsigc++-2.2.2:2
	>=net-misc/curl-7.19.1
	sys-libs/ncurses
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	daemon? ( app-misc/screen )
	bad_peer_handling? ( net-libs/libtorrent[bad_peer_handling] )"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-canvas-fix.patch
	if use bad_peer_handling; then
		epatch "${FILESDIR}/bad_peer_handling.patch"
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
	if use bad_peer_handling; then
		dodoc "${FILESDIR}/bad_peer_handling.README"
	fi

	if use daemon; then
		newinitd "${FILESDIR}/rtorrentd.init" rtorrentd || die "newinitd failed"
		newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd || die "newconfd failed"
	fi
}

pkg_postinst() {
	elog "rtorrent colors patch"
	elog "Set colors using the options below in .rtorrent.rc:"
	elog "Options: done_fg_color, done_bg_color, active_fg_color, active_bg_color"
	elog "Colors: 0 = black, 1 = red, 2 = green, 3 = yellow, 4 = blue,"
	elog "5 = magenta, 6 = cyan and 7 = white"
	elog "Example: done_fg_color = 1"
	if use bad_peer_handling; then
		echo
		einfo
		einfo 'rtorrent was built with bad_pear_handling patch enabled!'
		einfo 'You need edit your .rtorrent.rc in order to enable bad_pear_handling'
		einfo 'Example:'
		einfo 'schedule = snub_leechers,120,120,"snub_leechers=10,5,1M"'
		einfo 'schedule = ban_slow_peers,120,120,"ban_slow_peers=5,2K,64K,5,128K,10,1M,30"'
		einfo 'system.method.set_key = event.download.finished,unban,"d.unban_peers="'
		einfo 'system.method.set_key = event.download.finished,unsnub,"d.unsnub_peers="'
		einfo
		einfo "check /usr/share/doc/${PF}/bad_peer_handling.README for more info"
		einfo
	fi

}
