# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Partition cloning tool"
HOMEPAGE="http://partclone.org"
SRC_URI="http://github.com/Thomas-Tsai/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="btrfs reiserfs reiser4 hfs fat minix ntfs jfs static vmfs xfs"

# xfsprogs, see https://bugs.gentoo.org/show_bug.cgi?id=486514
RDEPEND="${common_depends}
	sys-fs/e2fsprogs
	btrfs? ( sys-fs/btrfs-progs )
	fat? ( sys-fs/dosfstools )
	ntfs? ( sys-fs/ntfs3g )
	hfs? ( sys-fs/hfsutils )
	jfs? ( sys-fs/jfsutils )
	reiserfs? ( sys-fs/progsreiserfs )
	reiser4? ( sys-fs/reiser4progs )
	xfs? ( >=sys-fs/xfsprogs-3.1.11-r1 )
	static? ( sys-fs/e2fsprogs[static-libs]
		      sys-fs/xfsprogs[static-libs]
		      sys-libs/ncurses[static-libs]
		      sys-fs/ntfs3g[static-libs]
		   )"
DEPEND=""

src_unpack()
{
	unpack ${A}
	#epatch "${FILESDIR}/${PN}-xfslib.patch"
	cd ${S}
}

src_compile() 
{
	local myconf
	myconf="${myconf} --enable-extfs --enable-ncursesw --enable-fs-test"
	use xfs && myconf="${myconf} --enable-xfs"
	use reiserfs && myconf="${myconf} --enable-reiserfs"
	use reiser4 && myconf="${myconf} --enable-reiser4"
	use hfs && myconf="${myconf} --enable-hfsp"
	use fat && myconf="${myconf} --enable-fat --enable-exfat"
	use ntfs && myconf="${myconf} --enable-ntfs"
	use minix && myconf="${myconf} --enable-minix"
	use jfs && myconf="${myconf} --enable-jfs"
	use btrfs && myconf="${myconf} --enable-btrfs"
	use vmfs && myconf="${myconf} --enable-vmfs"
	use static && myconf="${myconf} --enable-static"

	econf ${myconf} || die "econf failed"
	emake || die "make failed"
}

src_install()
{
	#emake install || die "make install failed"
	#emake DIST_ROOT="${D}" install || die "make install failed"
	cd ${S}/src
	dosbin partclone.dd partclone.restore partclone.chkimg
	dosbin partclone.extfs
	use xfs && dosbin partclone.xfs
	use reiserfs && dosbin partclone.reiserfs
	use reiser4 && dosbin partclone.reiser4
	use hfs && dosbin partclone.hfsp
	use fat && dosbin partclone.fat
	use ntfs && dosbin partclone.ntfs
	use ntfs && dosbin partclone.ntfsfixboot
}

