#!/bin/zsh

letsencrypt_dir=$HOME/var/letsencrypt

PYTHONWARNINGS=ignore certbot "$@" -n --agree-tos --email admin@flowlogix.com \
--logs-dir $HOME/var/log/letsencrypt --config-dir $letsencrypt_dir \
--work-dir $letsencrypt_dir/lib
