#!/bin/sh

SCRIPT_DIR=`dirname "$0"`
exports_dir=$SCRIPT_DIR/context/exports

mkdir -p $exports_dir/repository

docker run -it --rm -v $exports_dir/repository:/home/flowlogix/.m2/repository \
  -v $SCRIPT_DIR/../downloads:/home/flowlogix/scripts $1 \
  sh -c "addgroup -g 1000 flowlogix && adduser -u 1000 -G flowlogix -D -g '' flowlogix \
  && apk --no-cache add git \
  && su - flowlogix -c scripts/precache-maven.sh"
