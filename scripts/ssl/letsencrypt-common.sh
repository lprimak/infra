#!/bin/bash -p

letsencrypt_dir=$HOME/var/letsencrypt

certbot "$@" -n --webroot --agree-tos --email admin@flowlogix.com \
--webroot-path ~website/contents \
--logs-dir $HOME/var/log/letsencrypt --config-dir $letsencrypt_dir \
--work-dir $HOME/var/lib

