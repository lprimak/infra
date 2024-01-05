#!/bin/zsh -p

SCRIPT_DIR=`dirname "$0"`

. $SCRIPT_DIR/common/functions.sh

setup
docker build -t docker-builder -f $SCRIPT_DIR/_builders/docker.dockerfile $SCRIPT_DIR/context
container=$(docker create -it --rm \
    -v /var/run/docker.sock:/var/run/docker.sock docker-builder)
docker start $container
$SCRIPT_DIR/install-container-infra.sh $container /root
docker attach $container
docker rmi docker-builder
