EAPI="5"

github_user='corecode'
github_tag='v0.8'

DESCRIPTION="DragonFly Mail Agent, a small Mail Transport Agent (MTA), designed for home and office use."
HOMEPAGE="https://github.com/corecode/dma"
SRC_URI="https://github.com/${github_user}/${PN}/tarball/${github_tag} -> ${PN}-github_tarball-${PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+mta"

DEPEND=""
RDEPEND="${DEPEND}
	net-mail/mailbase
	mta? (
		!net-mail/mailwrapper
		!mail-mta/courier
		!mail-mta/esmtp
		!mail-mta/exim
		!mail-mta/mini-qmail
		!mail-mta/msmtp[mta]
		!mail-mta/nbsmtp
		!mail-mta/netqmail
		!mail-mta/nullmailer
		!mail-mta/postfix
		!mail-mta/qmail-ldap
		!mail-mta/sendmail
	)"

src_unpack() {
	unpack "$A"
	mv "${WORKDIR}/${github_user}-${PN}"-??????? "${S}"
}

src_compile() {
	emake PREFIX='/usr' LIBEXEC='/usr/lib/dma'
}

src_install() {
	emake DESTDIR="$D" PREFIX='/usr' LIBEXEC='/usr/lib/dma' VARMAIL='/var/spool/mail' install install-etc
	chmod 750 "$D/etc/dma"
	chown root:mail "$D/etc/dma"
	chmod 640 "$D/etc/dma/dma.conf" 

	cat >>"$D/etc/dma/dma.conf" <<-'EOF'
	
	# GMAIL relay example
	#SMARTHOST smtp.gmail.com
	#PORT 587
	#AUTHPATH /etc/dma/auth.conf
	#SECURETRANSFER
	#STARTTLS
	#INSECURE
	EOF

	if use mta; then 
		ln -s 'dma' "$D/usr/sbin/sendmail"
		mkdir -p "$D/usr/bin" && ln -s '../sbin/dma' "$D/usr/bin/sendmail"
	fi

	install -d -m 3775 -o root -g mail "$D/var/spool/dma"
	# bug #457162
	# keepdir /var/spool/dma
	touch "$D/var/spool/dma/.keep_${CATEGORY}_${PN}-${SLOT%/*}"
}

