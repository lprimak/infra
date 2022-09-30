#!/bin/bash -p

SCRIPT_DIR=`dirname "$0"`

asadmin multimode -f $SCRIPT_DIR/create-hope-website.cmds

domain_dir=$HOME/var/payara-domains/hope-website/config
keytool -importkeystore -srckeystore $domain_dir/cacerts.jks -destkeystore $domain_dir/cacerts.jks -deststoretype pkcs12 -srcstorepass changeit -deststorepass changeit 2>/dev/null
$SCRIPT_DIR/import-certs.sh

asadmin create-password-alias hope-db-username --passwordfile $HOME/var/secrets/hope-db-usernamefile
asadmin create-password-alias hope-db-password --passwordfile $HOME/var/secrets/hope-db-passwordfile
asadmin create-password-alias hope-smtp-user --passwordfile $HOME/var/secrets/hope-smtp-usernamefile
asadmin create-password-alias hope-smtp-password --passwordfile $HOME/var/secrets/hope-smtp-passwordfile
asadmin create-password-alias com.flowlogix.cipher-key --passwordfile $HOME/var/secrets/shiro-cipher-keyfile

asadmin deploy --contextroot mail $HOME/apps/cubusmail/bin/cubusmail.war
asadmin deploy --contextroot jee-examples --availabilityenabled $HOME/apps/hope-apps/jee-examples.war
asadmin deploy --contextroot em --availabilityenabled $HOME/apps/hope-apps/hope-website.war

asadmin restart-domain
