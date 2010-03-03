# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=2

inherit eutils linux-info linux-mod toolchain-funcs versionator

MY_PV=$(get_version_component_range 1-2)
MY_BUILD=$(get_version_component_range 3)
MY_P="oss-v${MY_PV}-build${MY_BUILD}-src-gpl"

DESCRIPTION="Open Sound System - portable, mixing-capable, high quality sound system for Unix."
HOMEPAGE="http://developer.opensound.com/"
SRC_URI="http://www.4front-tech.com/developer/sources/stable/gpl/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="gtk salsa"

RESTRICT="mirror"

DEPEND="sys-apps/gawk 
	gtk? ( >=x11-libs/gtk+-2 ) 
	>=sys-kernel/linux-headers-2.6.11
	!media-sound/oss-devel"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

build_oss_modules() {
	TOPDIR=${WORKDIR}/build/prototype/
	UNAME=${KV_FULL}

        echo "OSSLIBDIR=/usr/lib/oss" > ${TOPDIR}etc/oss.conf
        OSSLIBDIR=${TOPDIR}usr/lib/oss

        cd $OSSLIBDIR/build

        rm -f $OSSLIBDIR/.cuckoo_installed

        if ${TOPDIR}usr/sbin/ossvermagic -r || /sbin/modinfo ext3|grep -q REGPARM
        then
                REGPARM=REGPARM
                rm -rf $OSSLIBDIR/objects
                ln -s $OSSLIBDIR/objects.regparm $OSSLIBDIR/objects
                rm -rf $OSSLIBDIR/modules
                ln -s $OSSLIBDIR/modules.regparm $OSSLIBDIR/modules
        else
                REGPARM=NOREGPARM
                rm -rf $OSSLIBDIR/objects
                ln -s $OSSLIBDIR/objects.noregparm $OSSLIBDIR/objects
                rm -rf $OSSLIBDIR/modules
                ln -s $OSSLIBDIR/modules.noregparm $OSSLIBDIR/modules
        fi

        [ -f $OSSLIBDIR/objects/osscore.o ] || die "OSS core module for $REGPARM kernel is not available in $OSSLIBDIR/objects"

        einfo "OSS build environment set up for $REGPARM kernels"

        KERNELDIR=/lib/modules/$UNAME/build

        [ -d /lib/modules/$UNAME ] || die "Kernel directory /lib/modules/$UNAME does not exist"

        cp -f ../objects/osscore.o osscore_mainline.o

        rm -f Makefile
        ln -s Makefile.osscore Makefile

        einfo "Building module osscore"

        make KERNELDIR=$KERNELDIR || die "Failed to compile OSS"

        mkdir -p ${TOPDIR}lib/modules/$UNAME/kernel/oss || die "OSS module directory ${TOPDIR}/lib/modules/$UNAME/kernel/oss does not exist."

        ld -r osscore.ko osscore_mainline.o -o ${TOPDIR}lib/modules/$UNAME/kernel/oss/osscore.ko || die "Linking the osscore module failed."

        if [ -f Module.symvers ]
        then
                #Take generated symbol information and add it to module.inc
                echo "static const struct modversion_info ____versions[]" > osscore_symbols.inc
                echo " __attribute__((used))" >> osscore_symbols.inc
                echo "__attribute__((section(\"__versions\"))) = {" >> osscore_symbols.inc
                sed -e "s:^:{:" -e "s:\t:, \":" -e "s:\t\(.\)*:\"},:" < Module.symvers >> osscore_symbols.inc
                echo "};" >> osscore_symbols.inc
        else
                echo > osscore_symbols.inc
        fi

        for n in ../modules/*.o
        do
                N=`basename $n .o`
                einfo "Building module $N"

                rm -f $N_mainline.o Makefile

                sed "s/MODNAME/$N/" < Makefile.tmpl > Makefile
                ln -s $n $N_mainline.o
                make KERNELDIR=$KERNELDIR || die "Compiling module $N failed"

                ld -r $N.ko $N_mainline.o -o ${TOPDIR}lib/modules/$UNAME/kernel/oss/$N.ko || die "Linking $N module failed"

                rm -f $N_mainline.o
                make clean
        done

        rm -f Makefile

        # update_depmod

        # Copy config files for any new driver modules

        [ -d $OSSLIBDIR/conf ] || mkdir $OSSLIBDIR/conf

        if [ -d $OSSLIBDIR/conf.tmpl ]
        then
                for n in $OSSLIBDIR/conf.tmpl/*.conf
                do
                        N=`basename $n`

                        [ -f $OSSLIBDIR/conf/$N ] || cp -f $n $OSSLIBDIR/conf/
                done
                rm -rf $OSSLIBDIR/conf.tmpl
        fi

        # [ -f $OSSLIBDIR/etc/installed_drivers ] || ${TOPDIR}usr/sbin/ossdetect -v

        [ -d ${TOPDIR}etc/init.d ] || mkdir ${TOPDIR}etc/init.d

        cp -f $OSSLIBDIR/etc/S89oss ${TOPDIR}etc/init.d/oss

        chmod 744 ${TOPDIR}etc/init.d/oss

        rm -f `ls -l -d /dev/*|grep ^c|grep '    14, '|sed 's/.* //'`

        # Recompile libflashsupport.so if possible. Otherwise use the precompiled
        # version.
        (cd $OSSLIBDIR/lib;cc -m64 -shared -fPIC -O2 -Wall -Werror flashsupport.c -o $OSSLIBDIR/lib/libflashsupport_64.so) > /dev/null 2>&1
        (cd $OSSLIBDIR/lib;cc -m32 -shared -fPIC -O2 -Wall -Werror flashsupport.c -o $OSSLIBDIR/lib/libflashsupport_32.so) > /dev/null 2>&1

        [ -f $OSSLIBDIR/etc/userdefs ] || echo "autosave_mixer yes" > $OSSLIBDIR/etc/userdefs

        # Hal 0.5.0+ hotplug
        mkdir -p ${TOPDIR}usr/lib/hal/scripts

        ln -sf $OSSLIBDIR/scripts/oss_usb-create-devices ${TOPDIR}usr/lib/hal/scripts/
        mkdir -p ${TOPDIR}usr/share/hal/fdi/policy/20thirdparty/
        ln -sf $OSSLIBDIR/scripts/90-oss_usb-create-device.fdi ${TOPDIR}usr/share/hal/fdi/policy/20thirdparty/
}

pkg_setup() {
	linux-mod_pkg_setup
}

src_prepare() {
	mkdir "${WORKDIR}/build"

	einfo "Replacing init script with gentoo friendly one ..."
	cp "${FILESDIR}/oss" "${S}/setup/Linux/oss/etc/S89oss"

	# Add -nopie to disable PIE for kernel modules
	gcc-specs-pie && epatch "${FILESDIR}/${P}-nopie.patch"
}

src_configure() {
	local myconf="$(! use salsa && echo \"--enable-libsalsa=NO\")"
	
	cd "${WORKDIR}/build"

	# Configure has to be run from build dir with full path.
	"${S}"/configure \
		${myconf} || die "configure failed"
}

src_compile() {
	cd "${WORKDIR}/build"

	emake build
}
	
src_install() {
	build_oss_modules

	newinitd "${FILESDIR}/oss" oss
	cp -R "${WORKDIR}"/build/prototype/* "${D}" 
}

pkg_postinst() {
	update_depmod

	/usr/sbin/ossdetect -v

	elog "In order to use OSSv4.2 you must run"
	elog "# /etc/init.d/oss start "
	elog ""
	elog "If you are upgrading from a older OSSv4 you must run"
	elog "# /etc/init.d/oss restart "
	elog ""
	elog "Enjoy OSSv4.2!"
}
