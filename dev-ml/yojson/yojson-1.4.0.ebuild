# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit findlib

DESCRIPTION="JSON parsing and pretty-printing library for OCaml"
HOMEPAGE="http://mjambon.com/yojson.html https://github.com/mjambon/yojson"
SRC_URI="https://github.com/mjambon/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/${PV}"
LICENSE="BSD"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND=">=dev-lang/ocaml-3.11:=[ocamlopt]
	dev-ml/easy-format:=[ocamlopt]
	>=dev-ml/biniou-1.2:=[ocamlopt]
"
DEPEND="${RDEPEND}
	dev-ml/cppo
	dev-ml/jbuilder
	dev-ml/cppo
"

src_install() {
	opam-installer -i \
		--prefix="${ED}/usr" \
		--libdir="${D}/$(ocamlc -where)" \
		--docdir="${ED}/usr/share/doc/${PF}" \
		${PN}.install || die

	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}