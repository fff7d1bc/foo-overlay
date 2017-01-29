# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils

DESCRIPTION="Snoopy will log execve() calls into syslog."
HOMEPAGE="https://github.com/a2o/snoopy"
SRC_URI="http://source.a2o.si/download/snoopy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	make DESTDIR="${D}" install
}

getlibdirname() {
	# Yes I could use multilib eclass and it's get_libdir but it would be overkill, really.
	if egrep -q '^/usr/lib64$' '/etc/ld.so.conf'; then
		echo "lib64"
	else
		echo "lib"
	fi
}

pkg_postinst() {
	# TODO: Translate text below to proper english.
	echo
	einfo "In order to audit selected binary, set LD_PRELOAD to snoopy before you execute it."
	einfo "For example: LD_PRELOAD=\"/usr/$(getlibdirname)/snoopy.so\" /usr/bin/vim"
	echo
	einfo "If you want audit system-wide, add snoopy to /etc/ld.so.preload:"
	einfo "echo '/usr/$(getlibdirname)/snoopy.so' >> /etc/ld.so.preload'"
	einfo "Make sure that /etc/ld.so.preload is world-readable."
	echo
}
