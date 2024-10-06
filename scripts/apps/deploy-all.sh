#!/bin/zsh

SCRIPT_DIR=`dirname "$0"`

$SCRIPT_DIR/download-all-apps.sh

asadmin deploy --force --contextroot jee-examples --availabilityenabled $HOME/apps/hope-apps/jee-examples.war
asadmin deploy --force --contextroot em --availabilityenabled $HOME/apps/hope-apps/hope-website.war
asadmin deploy --force --contextroot sg --availabilityenabled $HOME/apps/hope-apps/starter-generator.war
