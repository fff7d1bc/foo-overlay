
EAPI='3'

DESCRIPTION="Dropbox daemon, cli option."
HOMEPAGE="http://dropbox.com/"
SRC_URI="x86? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86-${PV}.tar.gz )
	amd64? ( http://dl-web.dropbox.com/u/17/dropbox-lnx.x86_64-${PV}.tar.gz )"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip"

QA_EXECSTACK_x86="opt/dropbox-cli/_ctypes.so"
QA_EXECSTACK_amd64="opt/dropbox-cli/_ctypes.so"

DEPEND=""
RDEPEND="!net-misc/dropbox
	net-misc/wget"

src_unpack() {
	unpack "${A}"
	mv "${WORKDIR}/.dropbox-dist" "${S}" || die
}

src_install() {
	# We don't need icons and default wrapper.
	rm -rf "${S}/icons" "${S}/dropboxd" || die

	local targetdir="/opt/dropbox-cli"
	insinto "${targetdir}" || die
	doins -r * || die
	doins "${FILESDIR}/dropbox-cli" || die
	fperms a+x "${targetdir}/dropbox" || die
	fperms a+x "${targetdir}/dropbox-cli"
	dosym "${targetdir}/dropbox-cli" "${targetdir}/dropboxd"
	dosym "${targetdir}/dropbox-cli" "/opt/bin/dropbox" || die
}
