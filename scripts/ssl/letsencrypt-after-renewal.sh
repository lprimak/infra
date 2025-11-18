#!/bin/zsh

SCRIPT_DIR=`dirname "$0"`

domain_name=hope-website
export domain_name
$SCRIPT_DIR/../payara/import-certs.sh 2>/dev/null

asadmin -I=false multimode << EOF
set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-2.enabled=false
set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-2.enabled=true
set configs.config.server-config.network-config.network-listeners.network-listener.admin-listener.enabled=false
set configs.config.server-config.network-config.network-listeners.network-listener.admin-listener.enabled=true
EOF

# haproxy
$SCRIPT_DIR/haproxy-update-certs.sh $HOME/var/ssl-links hope
$SCRIPT_DIR/haproxy-update-certs.sh $HOME/var/ssl-links fl
$SCRIPT_DIR/haproxy-update-certs.sh $HOME/var/ssl-links lp

ansible-playbook $HOME/infra/scripts/cloud/oci/install-webservers.yaml -t ssl

ssh web1 "sudo /usr/local/bin/haproxy-update-certs.sh /etc/ssl/certs/flowlogix hope"
ssh web1 "sudo /usr/local/bin/haproxy-update-certs.sh /etc/ssl/certs/flowlogix lp"
ssh web1 "sudo /usr/local/bin/haproxy-update-certs.sh /etc/ssl/certs/flowlogix fl"

# Email Notification
# Original script located at https://github.com/hstock/certbot-renew-email
$SCRIPT_DIR/certbot-notify-post-hook.py admin@flowlogix.com lprimak@hope.nyc.ny.us
