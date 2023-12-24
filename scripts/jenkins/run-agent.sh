#!/bin/bash -l

if [ $# -eq 0 ]; then
    echo "Usage: $0 <container_name>"
    exit 1
fi

if [ -f ~/.bashrc ]; then
  echo "Sourceing Bash"
    source ~/.bashrc
fi

unset AS_ADMIN_USER
unset AS_ADMIN_PASSWORDFILE

mkdir -p $HOME/apps/jenkins/current $HOME/var/jenkins
agent_path=$HOME/apps/jenkins/current/agent.jar
cd $HOME/var/jenkins

date_cmd=date
if hash gdate 2>/dev/null; then
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
        if [ $(wc -c <"$agent_path") -lt 100000 ]; then
            echo "Agent download failed"
            rm -f $agent_path
            sleep 1
            continue
        fi
    fi

    java -jar "$agent_path" \
        -url https://jenkins.hope.nyc.ny.us -name $1 -webSocket \
        -secret @$HOME/var/secrets/jenkins-agent -workDir "$HOME/var/jenkins/$1-node"
    sleep 1
done
