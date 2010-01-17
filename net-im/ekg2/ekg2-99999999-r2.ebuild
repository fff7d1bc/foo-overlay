# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

ESVN_REPO_URI="http://toxygen.net/svn/ekg2/trunk"

inherit eutils perl-module subversion

DESCRIPTION="Text based Instant Messenger and IRC client that supports protocols like Jabber and Gadu-Gadu"
HOMEPAGE="http://www.ekg2.org"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""

IUSE="autoresponder dbus nntp rss gadu gif jpeg gpg gsm gtk httprc icq ioctld irc jabber gnutls ssl jogger +logs oracle sqlite sqlite3 mail ncurses gpm spell oss pcm perl polchat python +rc -readline rivchat rot13 ruby sim sms pcap xmsg xosd unicode nls zlib inotify"

RDEPEND="dbus? ( sys-apps/dbus )
	rss? ( >=dev-libs/expat-1.95.6 )
	gadu? ( >=net-libs/libgadu-1.7.0
		jpeg? ( >=media-libs/jpeg-6b-r2 )
		gif? ( media-libs/giflib ) )
	gpg? ( >=app-crypt/gpgme-1.0.0 )
	gsm? ( >=media-sound/gsm-1.0.10 )
	gtk? ( >=x11-libs/gtk+-2.4 )
	jabber? ( >=dev-libs/expat-1.95.6
		gnutls? ( >=net-libs/gnutls-1.0.17 )
		!gnutls? ( ssl? (
			>=dev-libs/openssl-0.9.6m ) )
		zlib? ( sys-libs/zlib ) )
	logs? (
		zlib? ( sys-libs/zlib ) )
	sqlite3? ( dev-db/sqlite:3 )
	sqlite? ( !sqlite3? (
		dev-db/sqlite:0 ) )
	ncurses? ( sys-libs/ncurses[unicode?]
		gpm? ( >=sys-libs/gpm-1.20.1 )
		spell? ( >=app-text/aspell-0.50.5 ) )
	python? ( >=dev-lang/python-2.3.3 )
	perl? ( >=dev-lang/perl-5.2 )
	ruby? ( dev-lang/ruby )
	readline? ( sys-libs/readline )
	sim? ( >=dev-libs/openssl-0.9.6m )
	pcap? ( net-libs/libpcap )
	xosd? ( x11-libs/xosd )
	virtual/libintl"

DEPEND="dev-util/scons
	${RDEPEND}"

pkg_setup() {
	if ! use ncurses; then
		if use gtk; then
			ewarn 'gtk frontend is currently very experimental, you should consider compiling with ncurses too.'
		elif use readline; then
			ewarn 'readline frontend is unsupported now, please use ncurses instead.'
		else
			ewarn 'ekg2 is being compiled with no frontend, you should consider enabling either ncurses, readline or gtk USEflag.'
		fi
	fi
}

use_plug() {
	use "$1" && echo -n ",${2:-$1}"
}

build_plugin_list() {
	echo '@none' \
	$(use_plug autoresponder) \
	$(use_plug dbus) \
	$(use_plug nntp feed) \
	$(use_plug rss feed) \
	$(use_plug gadu gg) \
	$(use_plug gpg) \
	$(use_plug gsm) \
	$(use_plug gtk) \
	$(use_plug httprc httprc_xajax) \
	$(use_plug icq) \
	$(use_plug ioctld) \
	$(use_plug irc) \
	$(use_plug jabber) \
	$(use_plug jogger) \
	$(use_plug logs) \
	$(use_plug oracle logsoracle) \
	$(use_plug sqlite logsqlite) \
	$(use_plug sqlite3 logsqlite) \
	$(use_plug mail) \
	$(use_plug ncurses) \
	$(use_plug oss) \
	$(use_plug pcm) \
	$(use_plug perl) \
	$(use_plug polchat) \
	$(use_plug python) \
	$(use_plug rc) \
	$(use_plug readline) \
	$(use_plug rivchat) \
	$(use_plug rot13) \
	$(use_plug ruby) \
	$(use_plug sim) \
	$(use_plug sms) \
	$(use_plug pcap sniff) \
	$(use_plug xmsg) \
	$(use_plug xosd) \
		| sed -e 's/\s*//g'
}

use_deps() {
	echo -n "$1_DEPS="

	shift
	while [ -n "$1" ]; do
		if use $1; then
			echo -n "+$2,"
		else
			echo -n "-$2,"
		fi
		shift
		shift
	done

	echo -n ' '
}

build_addopts_list() {
	if use jabber; then
		if use gnutls; then
			echo -n 'JABBER_DEPS=+gnutls'
		elif use ssl; then
			echo -n 'JABBER_DEPS=+openssl'
		else
			echo -n 'JABBER_DEPS=-gnutls,-openssl'
		fi

		if use zlib; then
			echo -n ',+zlib '
		else
			echo -n ',-zlib '
		fi
	fi

	if use sqlite3; then
		echo -n 'LOGSQLITE_DEPS=+sqlite3 '
	elif use sqlite; then
		echo -n 'LOGSQLITE_DEPS=+sqlite '
	fi

	if use ncurses; then
		use_deps NCURSES gpm gpm spell aspell
	fi

	if use rss; then
		echo -n 'FEED_DEPS=+expat '
	elif use nntp; then
		echo -n 'FEED_OPTS=-expat '
	fi

	if use gadu; then
		use_deps GG gif gif jpeg jpeg
	fi

	if use logs; then
		use_deps LOGS zlib zlib
	fi

	if use xmsg; then
		use_deps XMSG inotify inotify
	fi
}

src_configure() {
	true
}

src_compile() {
	scons "PLUGINS=$(build_plugin_list)" $(build_addopts_list) \
		PREFIX=/usr DESTDIR="${D}" HARDDEPS=1 DOCDIR="\$DATAROOTDIR/doc/${PF}" \
		$(use unicode || echo -n 'UNICODE=0') $(use nls || echo -n 'NLS=0') \
		DISTNOTES="emdzientoo ebuild ${PVR}, USE=${USE}" ${MAKEOPTS} || die "scons failed"

	if use perl; then
		cd plugins/perl
		for DIR in */; do
			cd "${DIR}"
			perl-module_src_prep
			perl-module_src_compile
			cd ..
		done
		cd ../..
	fi
}

src_test() {
	if use perl; then
		cd plugins/perl
		for DIR in */; do
			cd "${DIR}"
			perl-module_src_test
			cd ..
		done
		cd ../..
	fi
}

src_install() {
	scons install || die "scons install failed"

	if use perl; then
		cd plugins/perl
		for DIR in */; do
			cd "${DIR}"
			perl-module_src_install
			cd ..
		done
		cd ../..

		fixlocalpod
	fi

	prepalldocs
}

pkg_postinst() {
	elog "EKG2 is still considered very experimental. Please do report all issues"
	elog "to mailing list ekg2-users@lists.ziew.org (you can write in English)."
	elog "Please do not file bugs to Gentoo Bugzilla."
	elog
	elog "Before reporting a bug, please check if it's reproducible and get"
	elog "complete backtrace of it. Even if you can't reproduce it, you may let us"
	elog "know that something like that happened."
	elog
	elog "How to get backtraces:"
	elog "	http://www.gentoo.org/proj/en/qa/backtraces.xml"
	elog
	elog "Thank you and have fun."

#	use perl && updatepod
}
