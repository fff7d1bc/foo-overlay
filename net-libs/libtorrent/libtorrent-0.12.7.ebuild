# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libtorrent/libtorrent-0.12.6.ebuild,v 1.7 2010/08/18 04:39:47 jer Exp $

EAPI=2
inherit eutils libtool

DESCRIPTION="LibTorrent is a BitTorrent library written in C++ for *nix."
HOMEPAGE="http://libtorrent.rakshasa.no/"
SRC_URI="http://libtorrent.rakshasa.no/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="debug ipv6 ssl +aggressive_optimizations"

RDEPEND=">=dev-libs/libsigc++-2.2.2:2
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	if use aggressive_optimizations; then
		epatch "${FILESDIR}/decrease_the_time_delay_when_your_client_connects_to_the_trackers.patch"
		epatch "${FILESDIR}/disconnect_idle_clients_quickly.patch"
		epatch "${FILESDIR}/quicker_ncurses_gui_update.patch"
		epatch "${FILESDIR}/increase_the_rate_at_which_pieces_are_requested_from_other_peers.patch"
	fi
	epatch "${FILESDIR}"/libtorrent-0.12.6-gcc44.patch
	elibtoolize
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--enable-aligned \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable ssl openssl) \
		--with-posix-fallocate

}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README
}
