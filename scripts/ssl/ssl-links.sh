#!/bin/zsh

cert_links_src=$HOME/var/letsencrypt/live
cert_links_dst=$HOME/var/ssl-links

rm -rf $cert_links_dst
mkdir -p $cert_links_dst

ln -s $cert_links_src/hope.nyc.ny.us/fullchain.pem $cert_links_dst/hope-fullchain.pem
ln -s $cert_links_src/hope.nyc.ny.us/privkey.pem $cert_links_dst/hope-fullchain.pem.key
ln -s $cert_links_src/lennyprimak.com/fullchain.pem $cert_links_dst/lp-fullchain.pem
ln -s $cert_links_src/lennyprimak.com/privkey.pem $cert_links_dst/lp-fullchain.pem.key
ln -s $cert_links_src/flowlogix.com/fullchain.pem $cert_links_dst/fl-fullchain.pem
ln -s $cert_links_src/flowlogix.com/privkey.pem $cert_links_dst/fl-fullchain.pem.key
