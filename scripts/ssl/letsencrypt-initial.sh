#!/bin/zsh

SCRIPT_DIR=`dirname "$0"`

cert_links_src=$HOME/var/letsencrypt/live
cert_links_dst=$HOME/var/ssl-links

$SCRIPT_DIR/letsencrypt-common.sh certonly \
-d '*.hope.nyc.ny.us,hope.nyc.ny.us' \
--authenticator dns-dynu --dns-dynu-credentials $HOME/var/secrets/dynu-credentials.ini \
"$@"

$SCRIPT_DIR/letsencrypt-common.sh certonly -d 'lennyprimak.com,www.lennyprimak.com' "$@"

rm -rf $cert_links_dst
mkdir -p $cert_links_dst
ln -s $cert_links_src/hope.nyc.ny.us/fullchain.pem $cert_links_dst/hope-fullchain.pem
ln -s $cert_links_src/hope.nyc.ny.us/privkey.pem $cert_links_dst/hope-fullchain.pem.key
ln -s $cert_links_src/lennyprimak.com/fullchain.pem $cert_links_dst/lp-fullchain.pem
ln -s $cert_links_src/lennyprimak.com/privkey.pem $cert_links_dst/lp-fullchain.pem.key
