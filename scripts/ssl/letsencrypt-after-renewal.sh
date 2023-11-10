#!/bin/zsh

SCRIPT_DIR=`dirname "$0"`

domain_name=hope-website
export domain_name
$SCRIPT_DIR/../payara/import-certs.sh 2>/dev/null
OCI_DIR=$HOME/infra/scripts/cloud/oci

asadmin -I=false multimode << EOF
set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-2.enabled=false
set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-2.enabled=true
set configs.config.server-config.network-config.network-listeners.network-listener.admin-listener.enabled=false
set configs.config.server-config.network-config.network-listeners.network-listener.admin-listener.enabled=true
EOF

# haproxy
# hope crt
echo -e "set ssl cert $HOME/var/ssl-links/hope-fullchain.pem <<\n$(cat $HOME/var/ssl-links/hope-fullchain.pem*)\n" | \
socat tcp-connect:localhost:9999 -
echo "commit ssl cert $HOME/var/ssl-links/hope-fullchain.pem" | socat tcp-connect:localhost:9999 -

# lp crt
echo -e "set ssl cert $HOME/var/ssl-links/lp-fullchain.pem <<\n$(cat $HOME/var/ssl-links/lp-fullchain.pem*)\n" | \
socat tcp-connect:localhost:9999 -
echo "commit ssl cert $HOME/var/ssl-links/lp-fullchain.pem" | socat tcp-connect:localhost:9999 -

ansible-playbook -i $OCI_DIR/hosts -t ssl,reload_apache $OCI_DIR/install-webservers.yml
ansible-playbook -i $OCI_DIR/hosts -t ssl,reload_docker $OCI_DIR/install-docker.yml

# Email Notification
# Original script located at https://github.com/hstock/certbot-renew-email
$SCRIPT_DIR/certbot-notify-post-hook.py admin@flowlogix.com lprimak@hope.nyc.ny.us
