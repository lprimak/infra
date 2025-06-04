#!/bin/zsh

SCRIPT_DIR=`dirname "$0"`

EXAMPLES_VERSION=9.x-SNAPSHOT

$SCRIPT_DIR/download-app.sh https://jenkins.hope.nyc.ny.us/job/flowlogix-ee-integration/job/main/lastSuccessfulBuild/artifact/com/flowlogix/jee-examples/$EXAMPLES_VERSION/jee-examples-${EXAMPLES_VERSION}.war $HOME/apps/hope-apps/jee-examples.war
$SCRIPT_DIR/download-app.sh https://jenkins.hope.nyc.ny.us/job/flowlogix-org-repo/job/apps/job/main/lastSuccessfulBuild/artifact/com/flowlogix/apps-ear/1.x-SNAPSHOT/apps-ear-1.x-SNAPSHOT.ear $HOME/apps/hope-apps/hope-apps.ear
$SCRIPT_DIR/download-app.sh https://jenkins.hope.nyc.ny.us/job/lprimak-private-org-repo/job/myonlinelogbook/job/main/lastSuccessfulBuild/artifact/com/myonlinelogbook/logbook/1.x-SNAPSHOT/logbook-1.x-SNAPSHOT.war $HOME/apps/hope-apps/logbook.war
