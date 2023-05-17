#! /bin/bash
# add to cron
# 0 0 * * * /srv/atlas/certbot.sh

source /srv/atlas/email.sh

docker run -it --rm --name certbot \
	-v "/srv/atlas/data/certbot/etc:/etc/letsencrypt" \
	-v "/srv/atlas/data/certbot/var:/var/lib/letsencrypt" \
	-v "/srv/atlas/cloudflare-credentials.ini:/cloudflare-credentials.ini:ro" \
	certbot/dns-cloudflare \
	certonly \
		--non-interactive \
		--dns-cloudflare \
		--dns-cloudflare-credentials /cloudflare-credentials.ini \
		--agree-tos \
        --email "${email}" \
		-d atlas.jekotia.net \
		--server https://acme-v02.api.letsencrypt.org/directory


out="/srv/atlas/data/technitium/cert/atlas.jekotia.net.pfx"
certbot="/srv/atlas/data/certbot/etc/live/atlas.jekotia.net"

openssl pkcs12 -export \
	-password pass:password \
	-out "$out" \
	-inkey "${certbot}/privkey.pem" \
	-in "${certbot}/cert.pem" \
	-certfile "${certbot}/chain.pem"

chmod 600 "$out"
