EAPI="5"
DESCRIPTION="shellscripts and lua cgi wrapper"
HOMEPAGE="http://haserl.sourceforge.net/"
SRC_URI="mirror://sourceforge/haserl/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="lua bash-extensions"
DEPEND="lua? ( dev-lang/lua )"

src_configure() {
	econf \
		$(use_enable lua luashell) \
		$(use_enable bash-extensions)
			
}
