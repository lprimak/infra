#!/bin/bash -p

SCRIPT_DIR=`dirname "$0"`
. $SCRIPT_DIR/common/functions.sh
setup
docker_build lprimak/user-shell user-shell.dockerfile

docker_build lprimak/user-shell:java-${JAVA_VERSION} user-java-shell.dockerfile
docker_push_tag lprimak/user-shell java-${JAVA_VERSION} java
JAVA_VERSION=11 docker_build lprimak/user-shell:java-11 user-java-shell.dockerfile
JAVA_VERSION=17 docker_build lprimak/user-shell:java-17 user-java-shell.dockerfile
JAVA_VERSION=21 docker_build lprimak/user-shell:java-21 user-java-shell.dockerfile
