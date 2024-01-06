#!/bin/bash -p

SCRIPT_DIR=`dirname "$0"`
. $SCRIPT_DIR/common/functions.sh
setup
docker_build lprimak/jenkins-master agent-master.dockerfile
