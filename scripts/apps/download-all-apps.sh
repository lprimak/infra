#!/bin/zsh

SCRIPT_DIR=`dirname "$0"`

EXAMPLES_VERSION=9.x-SNAPSHOT

$SCRIPT_DIR/download-app.sh https://jenkins.hope.nyc.ny.us/job/flowlogix-ee-integration/job/main/lastSuccessfulBuild/artifact/com/flowlogix/jee-examples/$EXAMPLES_VERSION/jee-examples-${EXAMPLES_VERSION}.war $HOME/apps/hope-apps/jee-examples.war
$SCRIPT_DIR/download-app.sh https://jenkins.hope.nyc.ny.us/job/flowlogix-org-repo/job/apps/job/main/lastSuccessfulBuild/artifact/com/flowlogix/hope-website/1.x-SNAPSHOT/hope-website-1.x-SNAPSHOT.war $HOME/apps/hope-apps/hope-website.war
$SCRIPT_DIR/download-app.sh https://jenkins.hope.nyc.ny.us/job/flowlogix-org-repo/job/starter-generator/job/main/lastSuccessfulBuild/artifact/com/flowlogix/starter/starter-generator/1.x-SNAPSHOT/starter-generator-1.x-SNAPSHOT.war $HOME/apps/hope-apps/starter-generator.war
