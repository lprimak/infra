#!/bin/zsh

SCRIPT_DIR=`dirname "$0"`

$SCRIPT_DIR/letsencrypt-common.sh certonly -d '*.hope.nyc.ny.us,hope.nyc.ny.us' \
--authenticator dns-dynu --dns-dynu-credentials $HOME/var/secrets/dynu-credentials.ini \
"$@"

$SCRIPT_DIR/letsencrypt-common.sh certonly -d '*.flowlogix.com,flowlogix.com' \
--authenticator cpanel --cpanel-credentials $HOME/var/secrets/directnic-credentials.ini "$@"

$SCRIPT_DIR/letsencrypt-common.sh certonly -d 'lennyprimak.com,www.lennyprimak.com' \
--webroot -w $HOME/var/website-content "$@"

$SCRIPT_DIR/ssl-links.sh
