EAPI=4

inherit git-2

DESCRIPTION="aufs-utils for aufs3.0"
HOMEPAGE="http://aufs.sourceforge.net"
EGIT_REPO_URI="git://aufs.git.sourceforge.net/gitroot/aufs/aufs-util.git"
EGIT_MASTER='aufs3.0'

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="static"

DEPEND="!sys-fs/aufs
		!sys-fs/aufs2
		!sys-fs/aufs3"
RDEPEND="${DEPEND}"

src_compile() {
	kernel_dir="/usr/src/linux"
	kernel_headers="${kernel_dir}/usr"
	test -d "${kernel_dir}" || die "There is no /usr/src/linux"
		if ! test -d "${kernel_headers}"; then
		eerror "There is no '${kernel_headers}'."
		eerror "Forgot to do 'make headers_install in '${kernel_dir}'?"
	fi
	if ! test -f "${kernel_dir}/fs/aufs/aufs.h" || ! test -f "${kernel_headers}/include/linux/aufs_type.h"; then
		die "There is no aufs.h or aufs_type.h, forgot to patch kernel with aufs3?"
	fi

	if ! use static; then sed 's#-static##g' -i Makefile; fi

	make KDIR=/usr/src/linux C_INCLUDE_PATH=/usr/src/linux/usr/include
}
