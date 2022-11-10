#!/bin/zsh

letsencrypt_dir=$HOME/var/letsencrypt

certbot "$@" -n --agree-tos --email admin@flowlogix.com \
--logs-dir $HOME/var/log/letsencrypt --config-dir $letsencrypt_dir \
--work-dir $HOME/var/lib
