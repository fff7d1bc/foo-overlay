EAPI="5"
inherit eutils flag-o-matic toolchain-funcs multilib

DESCRIPTION="ash from busybox."
HOMEPAGE="http://www.busybox.net/"

base='busybox'
MY_P=${base}-${PV/_/-}

SRC_URI="
	http://www.busybox.net/downloads/${MY_P}.tar.bz2
"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="static"
RESTRICT="test"

RDEPEND=""
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	cat >"${S}/tmp.config" <<-END_OF_CONFIG
		CONFIG_ASH=y
		CONFIG_ASH_JOB_CONTROL=y
		CONFIG_ASH_ALIAS=y
		CONFIG_ASH_GETOPTS=y
		CONFIG_ASH_BUILTIN_ECHO=y
		CONFIG_ASH_BUILTIN_PRINTF=y
		CONFIG_ASH_BUILTIN_TEST=y
		CONFIG_ASH_CMDCMD=y
		CONFIG_ASH_RANDOM_SUPPORT=y
		CONFIG_ASH_EXPAND_PRMT=y
		CONFIG_SH_MATH_SUPPORT=y
		CONFIG_SH_MATH_SUPPORT_64=y
		CONFIG_FEATURE_SH_EXTRA_QUIET=y
		CONFIG_FEATURE_SH_HISTFILESIZE=y
		CONFIG_FEATURE_FANCY_ECHO=y
	END_OF_CONFIG

	if use static; then
		echo 'CONFIG_STATIC=y' >> "${S}/tmp.config"
	fi

	make KCONFIG_ALLCONFIG='tmp.config' allnoconfig >/dev/null 2>&1
}

src_prepare() {
	epatch "${FILESDIR}/busybox-1.20.2-glibc-sys-resource.patch"
}

src_install() {
	mkdir "${D}/bin" || die
	cp busybox "${D}/bin/ash" || die
	chmod 755 "${D}/bin/ash" || die
}
