#!/bin/zsh -l
source $HOME/.zshrc
SCRIPT_DIR=`dirname "$0"`

sleep 30; cd $SCRIPT_DIR; vagrant up

function shutdown() {
    cd $SCRIPT_DIR; vagrant halt
    exit 0
}
trap shutdown SIGTERM
while true; do
    sleep 86400 &
    wait $!
done
