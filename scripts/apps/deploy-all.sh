#!/bin/zsh -p

SCRIPT_DIR=`dirname "$0"`

$SCRIPT_DIR/download-all.sh

asadmin deploy --force --contextroot jee-examples --availabilityenabled $HOME/apps/hope-apps/jee-examples.war
asadmin deploy --force --contextroot em --availabilityenabled $HOME/apps/hope-apps/hope-website.war

