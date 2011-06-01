# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2-utils eutils autotools

MY_PN="HandBrake"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Open-source DVD to MPEG-4 converter"
HOMEPAGE="http://handbrake.fr/"
SRC_URI="http://handbrake.fr/rotation.php?file=${MY_PN}-${PV}.tar.bz2
		-> ${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="css doc gtk"
RDEPEND="sys-libs/zlib
	css? ( media-libs/libdvdcss )
	gtk? (	>=x11-libs/gtk+-2.8
			dev-libs/glib
			dev-libs/dbus-glib
			x11-libs/libnotify
			media-libs/gstreamer
			media-libs/gst-plugins-base
			>=sys-fs/udev-147[extras]
	)"
DEPEND="=sys-devel/automake-1.10*
	=sys-devel/automake-1.4*
	=sys-devel/automake-1.9*
	dev-lang/yasm
	>=dev-lang/python-2.4.6
	|| ( >=net-misc/wget-1.11.4 >=net-misc/curl-7.19.4 )
	$RDEPEND"

src_prepare() {
	epatch "${FILESDIR}/${PV}-backport-lib-fixes.patch"
	cd gtk
	eautoreconf
}

src_configure() {
	local myconf=""

	! use gtk && myconf="${myconf} --disable-gtk"

	./configure --force --prefix=/usr --disable-gtk-update-checks ${myconf} || die "configure failed"
}

src_compile() {
	WANT_AUTOMAKE=1.9 emake -C build || die "failed compiling ${PN}"
}

src_install() {
	emake -C build DESTDIR="${D}" install || die "failed installing ${PN}"

	if use doc; then
		emake -C build doc
			dodoc AUTHORS CREDITS NEWS THANKS \
				build/doc/articles/txt/* || die "docs failed"
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
