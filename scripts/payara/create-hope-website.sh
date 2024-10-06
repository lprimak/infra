#!/bin/zsh

SCRIPT_DIR=`dirname "$0"`

domain_name=hope-website
port_base=1100
cubusprops_file=cubus

export domain_name
asadmin create-domain --portbase $port_base $domain_name
asadmin start-domain $domain_name

asadmin multimode -f $SCRIPT_DIR/create-hope-website.cmds

domain_dir=$HOME/var/payara-domains/${domain_name}/config
if [ -f $domain_dir/cacerts.jks ]; then
    keytool -importkeystore -srckeystore $domain_dir/cacerts.jks -destkeystore $domain_dir/cacerts.jks -deststoretype pkcs12 -srcstorepass changeit -deststorepass changeit 2>/dev/null
fi
$SCRIPT_DIR/import-certs.sh

asadmin create-password-alias hope-db-username --passwordfile $HOME/var/secrets/hope-db-usernamefile
asadmin create-password-alias hope-db-password --passwordfile $HOME/var/secrets/hope-db-passwordfile
asadmin create-password-alias hope-smtp-user --passwordfile $HOME/var/secrets/hope-smtp-usernamefile
asadmin create-password-alias hope-smtp-password --passwordfile $HOME/var/secrets/hope-smtp-passwordfile
asadmin create-password-alias com.flowlogix.cipher-key --passwordfile $HOME/var/secrets/shiro-cipher-keyfile

asadmin create-system-properties cubus.config=$HOME/infra/etc/${cubusprops_file}.properties

asadmin deploy --force --contextroot mail $HOME/apps/cubusmail/bin/cubusmail.war
asadmin deploy --force --contextroot jee-examples --availabilityenabled $HOME/apps/hope-apps/jee-examples.war
asadmin deploy --force --contextroot em --availabilityenabled $HOME/apps/hope-apps/hope-website.war
asadmin deploy --force --contextroot sg --availabilityenabled $HOME/apps/hope-apps/starter-generator.war

asadmin restart-domain ${domain_name}
