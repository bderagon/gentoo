# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils flag-o-matic llvm python-single-r1

DESCRIPTION="Find unused include directives in C/C++ programs"
HOMEPAGE="https://include-what-you-use.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/clang_${PV}.tar.gz -> ${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-devel/llvm:4
	sys-devel/clang:4
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}/${PN}-clang_${PV}

pkg_setup() {
	llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang .
	default
}

src_configure() {
	local mycmakeargs=(
		-DIWYU_LLVM_INCLUDE_PATH=$(llvm-config --includedir)
		-DIWYU_LLVM_LIB_PATH=$(llvm-config --libdir)

		# Note [llvm install path]
		# Unfortunately all binaries using clang driver
		# have to reside at the same path depth as
		# 'clang' binary itself. See bug #625972
		# Thus as a hack we install it to the same directory
		# as llvm/clang itself.
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix)"
	)
	cmake-utils_src_configure
}

src_test() {
	"${EPYTHON}" run_iwyu_tests.py
}
