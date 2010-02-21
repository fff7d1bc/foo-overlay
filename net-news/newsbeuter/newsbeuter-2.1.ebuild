# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/newsbeuter/newsbeuter-2.0.ebuild,v 1.3 2009/08/30 12:25:25 tanderson Exp $

EAPI="2"
inherit toolchain-funcs eutils

DESCRIPTION="A RSS/Atom feed reader for the text console."
HOMEPAGE="http://www.newsbeuter.org/index.html"
SRC_URI="http://www.${PN}.org/downloads/${P}.tar.gz"
# test fail currently
RESTRICT=test

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="test"

RDEPEND=">=dev-db/sqlite-3.5:3
	>=dev-libs/stfl-0.21
	net-misc/curl
	dev-libs/libxml2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	test? ( dev-libs/boost )"

src_prepare() {
	sed -i \
		-e "s:-ggdb:${CXXFLAGS}:" \
		-e "s:^CXX=.*:CXX=$(tc-getCXX):" \
		Makefile
}

src_test() {
	emake test || die
	# Tests fail if in ${S} rather than in ${S}/test
	cd "${S}"/test
	./test || die
}

src_install() {
	emake prefix="${D}/usr" install || die
	dodoc AUTHORS README CHANGES
	mv "${D}"/usr/share/doc/${PN}/* "${D}"/usr/share/doc/${PF}/
	rm -rf "${D}"/usr/share/doc/${PN}
}
