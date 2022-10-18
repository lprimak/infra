#!/bin/zsh -p

letsencrypt_dir=$HOME/var/letsencrypt

certbot "$@" -n --authenticator dns-dynu \
--dns-dynu-credentials $HOME/var/secrets/dynu-credentials.ini \
--agree-tos --email admin@flowlogix.com \
--logs-dir $HOME/var/log/letsencrypt --config-dir $letsencrypt_dir \
--work-dir $HOME/var/lib
