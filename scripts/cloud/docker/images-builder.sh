#!/bin/zsh -p

SCRIPT_DIR=`dirname "$0"`

container=$(docker create -it --rm -w /build -e FL_IS_BUILD_IMAGE=yes \
    -v /var/run/docker.sock:/var/run/docker.sock docker /bin/ash)
docker start $container
docker exec $container sh -c "mkdir -p /root/.ssh; apk --update --no-cache add git"
$SCRIPT_DIR/install-container-infra.sh $container /root
docker exec $container sh -c "ln -s /root/infra/scripts/cloud/docker /build"
docker attach $container
