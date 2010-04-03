# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON=2.3

inherit flag-o-matic eutils distutils

DESCRIPTION="Create standalone executables from Python scripts"
HOMEPAGE="http://cx-freeze.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/cx-freeze/${P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="virtual/python"
DEPEND="${RDEPEND}"

strip-flags

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r doc/*
	fi
}

#we can't use the default pkg_postinst because we dont want 
#python_mod_optimize to byte compile initscripts and samples
pkg_postinst() {
	local pylibdir pymod
	if [[ -z "${PYTHON_MODNAME}" ]]; then
		for pylibdir in "${ROOT}"/usr/$(get_libdir)/python*; do
			if [[ -d "${pylibdir}"/site-packages/${PN} ]]; then
				PYTHON_MODNAME=${PN}
			fi
		done
	fi

	if has_version ">=dev-lang/python-2.3"; then
		python_version
		for pymod in ${PYTHON_MODNAME}; do
			pymoddir=/usr/$(get_libdir)/python${PYVER}/site-packages/${pymod}
			for pymodfile in "${pymoddir}/*.py"; do
				python_mod_compile ${pymodfile}
			done
		done
	fi
}

