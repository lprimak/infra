#!/bin/bash -p

SCRIPT_DIR=`dirname "$0"`
. $SCRIPT_DIR/common/functions.sh
setup
docker_build lprimak/user-shell user-shell.dockerfile
