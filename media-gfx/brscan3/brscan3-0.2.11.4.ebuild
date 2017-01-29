EAPI="5"

inherit versionator rpm

DESCRIPTION="Scanner driver"
HOMEPAGE="http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_scn.html#brscan3"
MY_PV="$(replace_version_separator 3 -)"
SRC_URI="
	amd64? ( http://www.brother.com/pub/bsc/linux/dlf/$PN-${MY_PV}.x86_64.rpm )
	x86? ( http://www.brother.com/pub/bsc/linux/dlf/$PN-${MY_PV}.i386.rpm )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="media-gfx/sane-backends[usb]"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	rpm_unpack "${A}" || die
}

src_install() {
	cp -r usr "${D}" || die

	# Preserve config, brsaneconfig3 will create the file for us.
	rm "${D}/usr/local/Brother/sane/brsanenetdevice3.cfg"

	mkdir -p "${D}/etc/sane.d/dll.d"
	echo "brother3" >"${D}/etc/sane.d/dll.d/brscan3.conf"
}

pkg_postinst() {
	"${ROOT}/usr/local/Brother/sane/setupSaneScan3" -i
	echo
	einfo "In order to use scanner you need to add it first with setupSaneScan3."
	einfo "Example with DCP-j315w over network:"
	einfo "	/usr/local/Brother/sane/brsaneconfig3 -a name=Scanner_Home_DCP-j315w model=DCP-J315W ip=192.168.0.24"
	einfo "	chmod 644 /usr/local/Brother/sane/brsanenetdevice3.cfg"

}

