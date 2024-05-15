#!/bin/zsh -l
source $HOME/.zshrc

asadmin start-domain hope-website

function shutdown() {
    asadmin stop-domain hope-website
    exit 0
}
trap shutdown SIGTERM
while true; do
    sleep 86400 &
    wait $!
done
