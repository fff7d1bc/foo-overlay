EAPI="4"
inherit eutils flag-o-matic toolchain-funcs multilib

DESCRIPTION="mdev from busybox."
HOMEPAGE="http://www.busybox.net/"

base='busybox'
MY_P=${base}-${PV/_/-}

SRC_URI="
	http://www.busybox.net/downloads/${MY_P}.tar.bz2
"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE="static +mdev-like-a-boss"
RESTRICT="test"

RDEPEND="
	!sys-apps/busybox[mdev]
	mdev-like-a-boss? ( sys-fs/mdev-like-a-boss )
"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.39"

S=${WORKDIR}/${MY_P}

src_configure() {
	cat >"${S}/tmp.config" <<-END_OF_CONFIG
		CONFIG_HAVE_DOT_CONFIG=y
		CONFIG_USE_PORTABLE_CODE=y
		CONFIG_PLATFORM_LINUX=y
		CONFIG_FEATURE_BUFFERS_USE_MALLOC=y
		CONFIG_SHOW_USAGE=y
		CONFIG_FEATURE_VERBOSE_USAGE=y
		CONFIG_FEATURE_COMPRESS_USAGE=y
		CONFIG_UNICODE_SUPPORT=y
		CONFIG_FEATURE_CHECK_UNICODE_IN_ENV=y
		CONFIG_UNICODE_COMBINING_WCHARS=y
		CONFIG_UNICODE_WIDE_WCHARS=y
		CONFIG_LONG_OPTS=y
		CONFIG_FEATURE_DEVPTS=y
		CONFIG_LFS=y
		CONFIG_NO_DEBUG_LIB=y
		CONFIG_INSTALL_APPLET_SYMLINKS=y
		CONFIG_MDEV=y
		CONFIG_FEATURE_MDEV_CONF=y
		CONFIG_FEATURE_MDEV_RENAME=y
		CONFIG_FEATURE_MDEV_RENAME_REGEXP=y
		CONFIG_FEATURE_MDEV_EXEC=y
		CONFIG_FEATURE_MDEV_LOAD_FIRMWARE=y
		CONFIG_FEATURE_SH_IS_NONE=y
		CONFIG_FEATURE_BASH_IS_NONE=y"
END_OF_CONFIG

	if use static; then
		echo 'CONFIG_STATIC=y' >> "${S}/tmp.config"
	fi

	# Landley's miniconfig. <3
	make KCONFIG_ALLCONFIG='tmp.config' allnoconfig >/dev/null 2>&1
}

src_install() {
	mkdir "${D}/sbin" || die
	cp busybox "${D}/sbin/mdev" || die
	chmod 750 "${D}/sbin/mdev" || die

	if use mdev-like-a-boss; then
		mkdir -p "${D}/etc" || die
		( cd "${D}/etc" && ln -s ../opt/mdev/mdev.conf ) || die
		newinitd "${ROOT}/opt/mdev/mdev.init" mdev || die
	fi
}

src_postinst() {
	if use mdev-like-a-boss; then
		if ! [ -e "${ROOT}/etc/runlevels/sysinit" ]; then
			ewarn
			ewarn "Remember to add mdev to sysinit runlevel by:"
			ewarn "    rc-update add mdev sysinit"
			ewarn
			ewarn "Also ensure that udev, udev-postmount and devfs"
			ewarn "aren't in any runlevel."
			ewarn
		fi
	fi
}
