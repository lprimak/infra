#!/bin/zsh -p

SCRIPT_DIR=`dirname "$0"`

docker build -t docker-builder -f $SCRIPT_DIR/_builders/docker.dockerfile $SCRIPT_DIR/_builders
container=$(docker create -it --rm \
    -v /var/run/docker.sock:/var/run/docker.sock docker-builder)
docker start $container
$SCRIPT_DIR/install-container-infra.sh $container /root
docker attach $container
docker rmi docker-builder
