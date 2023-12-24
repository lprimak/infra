#!/bin/zsh -p

if [ $# -lt 2 ]; then
    echo "Usage: $0 <container_name> <secret>"
    exit 1
fi

SCRIPT_DIR=`dirname "$0"`

home_dir=/home/flowlogix
tmp_file=$(mktemp)
echo "#!/bin/sh
sleep 30" > $tmp_file
chmod a+x $tmp_file
container=$(docker create --restart unless-stopped --name $1-jenkins-agent \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $home_dir/var/jenkins:$home_dir/var/jenkins \
lprimak/jenkins-master ./run-agent.sh $1)
docker cp -qa $tmp_file $container:$home_dir/run-agent.sh
rm $tmp_file
docker start $container
docker exec $container sh -c "mkdir -p .ssh var/secrets; chmod 700 var/secrets;
echo $2 > var/secrets/jenkins-agent; chmod 600 var/secrets/jenkins-agent"
$SCRIPT_DIR/enable-docker-github.sh $container $home_dir
docker exec -d $container sh -c "rm -f run-agent.sh; ln -s infra/scripts/jenkins/run-agent.sh \$HOME/run-agent.sh; \$HOME/run-agent.sh $1"
