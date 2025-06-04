#!/bin/zsh

SCRIPT_DIR=`dirname "$0"`

$SCRIPT_DIR/download-all-apps.sh

asadmin deploy --force --contextroot jee-examples --availabilityenabled $HOME/apps/hope-apps/jee-examples.war
asadmin deploy --force --name apps --availabilityenabled $HOME/apps/hope-apps/hope-apps.ear
asadmin deploy --force --name logbook --availabilityenabled $HOME/apps/hope-apps/logbook.war
