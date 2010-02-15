# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils libtool

DESCRIPTION="This library implements the client side of the Gadu-Gadu protocol"
HOMEPAGE="http://toxygen.net/libgadu/"
#SRC_URI="http://toxygen.net/libgadu/files/${P}.tar.gz"

ESVN_REPO_URI="http://toxygen.net/svn/libgadu/trunk/"
ECVS_MODULE="${PN}"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""

IUSE="ssl threads"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6m )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	subversion_src_unpack
	cd "${S}"

	sed -i \
		-e "s|GG_LIBGADU_VERSION \"CVS\"|GG_LIBGADU_VERSION \"SVN\"|" \
		include/libgadu.h.in || die "sed failed"

	sh autogen.sh
}

src_compile() {
	econf \
	    --enable-shared \
	    `use_with threads pthread` \
	    `use_with ssl openssl` \
	     || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	einstall || die
}
