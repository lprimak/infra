#!/bin/zsh

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <username>" >&2
  exit 1
fi
client_dir=client/$1
mkdir -p client
mkdir $client_dir
[ $? != 0 ] && exit 1
ln -s ../../server/root.crt $client_dir/
openssl ecparam -name prime256v1 -genkey -noout -out $client_dir/postgresql.key
openssl req -new -sha256 -key $client_dir/postgresql.key -out $client_dir/client.csr -subj "/CN=$1"

openssl x509 -req -in $client_dir/client.csr -CA $client_dir/root.crt -CAkey server/ca.key -CAcreateserial -out $client_dir/postgresql.crt -days 365 -sha256

chmod og-rwx,g+rw $client_dir/*.key $client_dir/postgresql.crt
rm -f $client_dir/*.csr $client_dir/*.srl $client_dir/root.crt

echo generate pk8 key:
echo openssl pkcs8 -topk8 -inform PEM -outform DER -nocrypt -in postgresql.key -out postgresql.pk8
