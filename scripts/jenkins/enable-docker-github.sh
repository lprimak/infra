#!/bin/zsh -p

container=$1
home_dir=$2

docker exec $container sh -c "\
echo \"Host github.com
    IdentityFile ~/.ssh/github-key.pem
    StrictHostKeyChecking = accept-new\" > $home_dir/.ssh/config"
docker cp -qa ~/.ssh/github-key.pem $container:$home_dir/.ssh
docker exec $container git clone git@github.com:lprimak/infra $home_dir/infra 2> /dev/null
