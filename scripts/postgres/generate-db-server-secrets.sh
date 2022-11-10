#!/bin/zsh

mkdir server
[ $? != 0 ] && exit 1
openssl ecparam -name prime256v1 -genkey -noout -out server/ca.key
openssl req -new -x509 -sha256 -key server/ca.key -out server/root.crt -subj "/CN=ca.flowlogix.com"

openssl ecparam -name prime256v1 -genkey -noout -out server/server.key
openssl req -new -sha256 -key server/server.key -out server/server.csr -subj "/CN=db.hope.nyc.ny.us"

openssl x509 -req -in server/server.csr -CA server/root.crt -CAkey server/ca.key -CAcreateserial -out server/server.crt -days 365 -sha256

chmod og-rwx server/*.key
