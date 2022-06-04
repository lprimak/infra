#!/bin/bash -p

SCRIPT_DIR=`dirname "$0"`

asadmin multimode -f $SCRIPT_DIR/create-hope-website.cmds

domain_dir=$HOME/var/payara-domains/hope-website/config
keytool -importkeystore -srckeystore $domain_dir/cacerts.jks -destkeystore $domain_dir/cacerts.jks -deststoretype pkcs12 -srcstorepass changeit -deststorepass changeit 2>/dev/null
$SCRIPT_DIR/import-certs.sh

asadmin deploy --contextroot mail $HOME/apps/cubusmail/bin/cubusmail.war
asadmin restart-domain

