#!/bin/zsh -p

container=$1
home_dir=$2
SCRIPT_DIR=$(dirname "$0")

docker exec $container sh -c "\
echo \"Host github.com
    IdentityFile ~/.ssh/github-key.pem
    StrictHostKeyChecking = accept-new\" > $home_dir/.ssh/config"
docker cp -qa ~/.ssh/github-key.pem $container:$home_dir/.ssh
docker cp -qa ~/var/secrets/docker-config.json $container:$home_dir/.docker/config.json
docker exec $container git clone git@github.com:lprimak/infra $home_dir/infra 2> /dev/null
docker cp -qa $SCRIPT_DIR/../../ $container:$home_dir/infra/
