#!/bin/zsh

[ $# -ne 2 ] && echo "Usage: $0 <links-dir> <cert-base>" && exit 1

links_dir=$1
cert_base=$2

echo -e "set ssl cert $links_dir/${cert_base}-fullchain.pem <<\n$(cat $links_dir/${cert_base}-fullchain.pem*)\n" | \
socat tcp-connect:localhost:9999 -
echo "commit ssl cert $links_dir/${cert_base}-fullchain.pem" | socat tcp-connect:localhost:9999 -
