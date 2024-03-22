#!/bin/bash -p

SCRIPT_DIR=`dirname "$0"`

. $SCRIPT_DIR/common/functions.sh
setup

create_maven_builders
create_payara_builders
$SCRIPT_DIR/_builders/cache.sh maven-4-builder

export_maven_from_builders
export_payara_from_builders

docker_build lprimak/jenkins-agent:m3-p5-jdk$JAVA_VERSION agent.dockerfile \
    --build-arg MAVEN_MAJOR_VERSION=3 --build-arg PAYARA_VERSION=5
docker_build lprimak/jenkins-agent:m4-p5-jdk$JAVA_VERSION agent.dockerfile \
    --build-arg MAVEN_MAJOR_VERSION=4 --build-arg PAYARA_VERSION=5
