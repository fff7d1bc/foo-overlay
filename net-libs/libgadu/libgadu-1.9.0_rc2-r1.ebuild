# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libgadu/libgadu-1.8.2.ebuild,v 1.8 2009/03/20 15:43:51 ranger Exp $

EAPI=2

inherit eutils libtool

MY_P="${P/_/-}"

DESCRIPTION="This library implements the client side of the Gadu-Gadu protocol"
HOMEPAGE="http://toxygen.net/libgadu/"
SRC_URI="http://toxygen.net/libgadu/files/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE="ssl threads"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6m )"
RDEPEND="${DEPEND}
	!=net-im/kadu-0.6.0.2
	!=net-im/kadu-0.6.0.1"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-images-gg10.patch"
}

src_configure() {
	econf \
	    --enable-shared \
	    $(use_with threads pthread) \
	    $(use_with ssl openssl) \
	     || die "econf failed"
}

src_install() {
	einstall || die
}
