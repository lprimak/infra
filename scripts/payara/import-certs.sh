#!/bin/zsh -p

letsencrypt_dir=$HOME/var/letsencrypt/live/hope.nyc.ny.us
domain_dir=$HOME/var/payara-domains/hope-website/config

openssl pkcs12 -export -in $letsencrypt_dir/fullchain.pem -inkey $letsencrypt_dir/privkey.pem -out $domain_dir/hope-cert.p12 -name hope.crt -password pass:changeit

keytool -importkeystore -destkeystore $domain_dir/keystore.jks -srckeystore $domain_dir/hope-cert.p12 -srcstoretype PKCS12 -srcstorepass changeit -deststorepass changeit -alias hope.crt --noprompt

rm -f $domain_dir/hope-cert.p12
