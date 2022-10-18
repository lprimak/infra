#!/bin/zsh -p

SCRIPT_DIR=`dirname "$0"`

$SCRIPT_DIR/../payara/import-certs.sh 2>/dev/null

asadmin -I=false multimode << EOF
set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-2.enabled=false
set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-2.enabled=true
set configs.config.server-config.network-config.network-listeners.network-listener.admin-listener.enabled=false
set configs.config.server-config.network-config.network-listeners.network-listener.admin-listener.enabled=true
EOF

# haproxy
echo -e "set ssl cert $HOME/var/ssl-links/fullchain.pem <<\n$(cat $HOME/var/ssl-links/fullchain.pem*)\n" | \
socat tcp-connect:localhost:9999 -
echo "commit ssl cert $HOME/var/ssl-links/fullchain.pem" | socat tcp-connect:localhost:9999 -

# Email Notification
# Original script located at https://github.com/hstock/certbot-renew-email
$SCRIPT_DIR/certbot-notify-post-hook.py admin@flowlogix.com lprimak@hope.nyc.ny.us
