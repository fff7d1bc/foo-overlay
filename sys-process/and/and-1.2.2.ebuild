# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
	
inherit eutils

DESCRIPTION="Auto Nice Daemon"
HOMEPAGE="http://and.sourceforge.net/"
SRC_URI="http://and.sourceforge.net/${P}.tar.gz	"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/Makefile.patch"
}

src_install() {
	doman *.5 *.8 || die
	dosbin and || die
	newinitd "${FILESDIR}/and.init" and || die
	dodoc CHANGELOG README LICENSE || die

	insinto /etc || die
	doins and.conf || die
	doins and.priorities || die

	insinto /etc/conf.d || die
	newins "${FILESDIR}/and.confd" and || die
}
