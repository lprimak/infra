#!/bin/zsh -l

source ~/.zshrc
unset AS_ADMIN_USER
unset AS_ADMIN_PASSWORDFILE

agent_path=$HOME/apps/jenkins/current/agent.jar
cd $HOME/var/jenkins

week_ago=$(gdate -d 'now - 7 days' +%s)
agent_time=$(gdate -r "$agent_path" +%s) 2>/dev/null

if [ ! -e "$agent_path" ] || (( agent_time <= week_ago )); then
    curl -s https://jenkins.hope.nyc.ny.us/jnlpJars/agent.jar -o "$agent_path"
fi

while true; do
    java -jar "$agent_path" \
        -jnlpUrl https://jenkins.hope.nyc.ny.us/computer/nova/jenkins-agent.jnlp \
        -secret @$HOME/var/secrets/jenkins-agent -workDir "$HOME/var/jenkins/hope-node"
    sleep 1
done
