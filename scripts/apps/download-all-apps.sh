#!/bin/zsh

SCRIPT_DIR=`dirname "$0"`

$SCRIPT_DIR/download-app.sh https://jenkins.hope.nyc.ny.us/job/flowlogix-ee-integration/job/main/lastSuccessfulBuild/artifact/com/flowlogix/jee-examples/6.x-SNAPSHOT/jee-examples-6.x-SNAPSHOT.war $HOME/apps/hope-apps/jee-examples.war
$SCRIPT_DIR/download-app.sh https://jenkins.hope.nyc.ny.us/job/flowlogix-org-repo/job/apps/job/main/lastSuccessfulBuild/artifact/com/flowlogix/hope-website/1.x-SNAPSHOT/hope-website-1.x-SNAPSHOT.war $HOME/apps/hope-apps/hope-website.war
