#!/bin/bash -l

source ~/.bashrc
unset AS_ADMIN_USER
unset AS_ADMIN_PASSWORDFILE

mkdir -p $HOME/apps/jenkins/current $HOME/var/jenkins
agent_path=$HOME/apps/jenkins/current/agent.jar
cd $HOME/var/jenkins

platform=$(uname)
date_cmd=date
if [ "$platform" == "Darwin" ]; then
  date_cmd=gdate
fi

while true; do
    week_ago=$($date_cmd -d 'now - 7 days' +%s)
    if [ -e "$agent_path" ]; then
      agent_time=$($date_cmd -r "$agent_path" +%s)
    fi

    if [ ! -e "$agent_path" ] || (( agent_time <= week_ago )); then
        echo "Downloading Agent ..."
        curl -s https://jenkins.hope.nyc.ny.us/jnlpJars/agent.jar -o "$agent_path"
    fi

    java -jar "$agent_path" \
        -jnlpUrl https://jenkins.hope.nyc.ny.us/computer/$1/jenkins-agent.jnlp \
        -secret @$HOME/var/secrets/jenkins-agent -workDir "$HOME/var/jenkins/hope-node"
    sleep 1
done
