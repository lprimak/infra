#!/bin/zsh

SCRIPT_DIR=`dirname "$0"`

cert_links_src=$HOME/var/letsencrypt/live/hope.nyc.ny.us
cert_links_dst=$HOME/var/ssl-links

exec $SCRIPT_DIR/letsencrypt-common.sh certonly \
-d '*.hope.nyc.ny.us,hope.nyc.ny.us,*.lennyprimak.com,lennyprimak.com' "$@"

rm -rf $cert_links_dst
mkdir -p $cert_links_dst
ln -s $cert_links_src/fullchain.pem $cert_links_dst/fullchain.pem 
ln -s $cert_links_src/privkey.pem $cert_links_dst/fullchain.pem.key
