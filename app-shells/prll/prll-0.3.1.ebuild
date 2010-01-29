# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="A utility for parallelizing execution in bash or zsh"
HOMEPAGE="http://prll.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-3 WTFPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

#src_prepare() {
#	epatch "${FILESDIR}/prll-0.2-makefile.patch"
#}

pkg_postinst() {
		echo
		einfo "File prll.sh contains the shell function. The shell that will use it"
		einfo "needs to source it. That means two things:"
		einfo "  - If you wish to use prll in a shell script, simply copy it in there."
		einfo "  - If you wish to use prll in an interactive shell, source it."
		einfo "The latter means that you need to put the function somewhere where"
		einfo "your shell will find it. You may need put or source it in your .bashrc or .zshrc."
		echo
}

src_install() {
	dobin ${PN}_jobserver || die "installation failed"
	insinto /etc/profile.d/
	doins ${PN}.sh || die "installation failed"
	dodoc AUTHORS README || die "dodoc failed"
}
