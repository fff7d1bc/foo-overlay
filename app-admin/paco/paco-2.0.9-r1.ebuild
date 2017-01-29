# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils autotools

EAPI="5"

DESCRIPTION="Source code package organizer"
HOMEPAGE="http://paco.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 x86 ~amd64 amd64"
IUSE="gtk +tools"

DEPEND="gtk? ( =dev-cpp/gtkmm-2* )
		virtual/pkgconfig"

RDEPEND="${DEPEND}"

src_prepare() {
	# Just in case.
	eautoreconf
}

src_configure() {
	local myconf="--with-paco-logdir=/var/lib/paco"
	if ! use gtk; then myconf+=" --disable-gpaco"; fi
	if ! use tools; then myconf+=" --disable-scripts"; fi
	econf ${myconf}
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc BUGS ChangeLog README doc/pacorc doc/faq.txt
	# We want docs in /usr/share/doc/paco.
	rm -fr "${D}/usr/share/paco" || die

	# Secure logdir.
	chmod 700 ${D}/var/lib/paco
}

pkg_postinst() {
	echo
	ewarn
	ewarn "This paco installation use /var/lib/paco instead of /var/log/paco."
	ewarn
	echo
	ewarn
	ewarn "If this is an upgrade from <=paco-2.0.9, remember to adjust permissions on /var/lib/paco."
	ewarn "	chmod 700 /var/lib/paco"
	ewarn "	chown root:root /var/lib/paco"
	ewarn
	echo
}
