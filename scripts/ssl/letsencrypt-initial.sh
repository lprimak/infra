#!/bin/bash -p

SCRIPT_DIR=`dirname "$0"`

cert_links_src=$HOME/var/letsencrypt/live/hope.nyc.ny.us
cert_links_dst=$HOME/var/ssl-links

exec $SCRIPT_DIR/letsencrypt-common.sh certonly \
-d hope.nyc.ny.us,apps.hope.nyc.ny.us,mail.hope.nyc.ny.us,\
mini.hope.nyc.ny.us,jenkins.hope.nyc.ny.us,admin.hope.nyc.ny.us,\
me.hope.nyc.ny.us,www.me.hope.nyc.ny.us "$@"

rm -rf $cert_links_dst
mkdir -p $cert_links_dst
ln -s $cert_links_src/fullchain.pem $cert_links_dst/fullchain.pem 
ln -s $cert_links_src/privkey.pem $cert_links_dst/fullchain.pem.key
