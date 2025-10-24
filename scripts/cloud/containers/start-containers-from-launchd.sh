#!/bin/zsh -l
source $HOME/.zshrc
SCRIPT_DIR=`dirname "$0"`

sleep 30; cd $SCRIPT_DIR
echo "Starting Vagrant containers at $(date) ..."
vagrant up
echo "Started Vagrant containers at $(date)"

function shutdown() {
    echo "Shutting down Vagrant containers at $(date) ..."
    cd $SCRIPT_DIR; vagrant halt
    echo "Shut down Vagrant containers at $(date)"
    exit 0
}
trap shutdown SIGTERM
while true; do
    sleep 86400 &
    wait $!
done
