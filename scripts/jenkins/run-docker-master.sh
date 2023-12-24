#!/bin/zsh -p

SCRIPT_DIR=`dirname "$0"`

container=$(docker create -it --rm -v /var/run/docker.sock:/var/run/docker.sock docker /bin/ash)
docker start $container
docker exec $container sh -c "mkdir -p /root/.ssh; apk --update --no-cache add git"
$SCRIPT_DIR/enable-docker-github.sh $container /root
docker attach $container
