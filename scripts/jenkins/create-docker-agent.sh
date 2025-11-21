#!/bin/zsh -p

if [ $# -lt 2 ]; then
    echo "Usage: $0 <container_name> <secret>"
    exit 1
fi

SCRIPT_DIR=$(dirname "$0")

home_dir=/home/flowlogix
container=$(docker create --init --restart unless-stopped --name $1-jenkins-agent \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $home_dir/var/jenkins:$home_dir/var/jenkins \
flowlogix/jenkins-master ./run-agent.sh $1)
docker cp -qa $SCRIPT_DIR/run-agent.sh $container:$home_dir/run-agent.sh
docker start $container
docker exec $container sh -c "mkdir -p .ssh var/secrets; chmod 700 var/secrets;
echo $2 > var/secrets/jenkins-agent; chmod 600 var/secrets/jenkins-agent"
$SCRIPT_DIR/../cloud/docker/install-container-infra.sh $container $home_dir
