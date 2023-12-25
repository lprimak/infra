#!/bin/sh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
exports_dir=$SCRIPT_DIR/context/exports

container=$(docker create -it $1 \
sh -c "addgroup -g 1000 flowlogix && adduser -u 1000 -G flowlogix -D -g '' flowlogix \
  && apk --no-cache add git \
  && su - flowlogix -c /var/build/precache-maven.sh")
docker cp -q $SCRIPT_DIR/../downloads/precache-maven.sh $container:/var/build/
docker start $container
docker attach $container
docker cp -q $container:/var/build/repo.tar.gz $exports_dir
docker rm $container > /dev/null

tar zxf $exports_dir/repo.tar.gz -C $exports_dir
rm -f $exports_dir/repo.tar.gz
