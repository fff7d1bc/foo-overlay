# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

EAPI=3

DESCRIPTION="Source code package organizer, make install wrapper."
HOMEPAGE="http://paco.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gtk nls"

DEPEND="gtk? ( =dev-cpp/gtkmm-2* )
		dev-util/pkgconfig
		nls? ( sys-devel/gettext )"

RDEPEND="${DEPEND}"

src_prepare() {
	# Just in case.
	eautoreconf
}


src_configure() {
	if use !gtk; then myconf+=" --disable-gpaco"; fi

	econf $myconf
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc BUGS ChangeLog README doc/pacorc doc/faq.txt
	
	# /usr/share/doc is better than /usr/share/paco.
	rm -fr "${D}/usr/share/paco" || die
}
