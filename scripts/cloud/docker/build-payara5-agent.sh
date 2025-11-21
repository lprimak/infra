#!/bin/bash -p

SCRIPT_DIR=`dirname "$0"`

. $SCRIPT_DIR/common/functions.sh
setup

# Payara 5 only works upto JDK 21, no later
JAVA_VERSION=21

create_maven_builders
create_payara_builders 5
$SCRIPT_DIR/_builders/cache.sh maven-4-builder

export_maven_from_builders
export_payara_from_builders 5

docker_build flowlogix/jenkins-agent:m3-p5-jdk$JAVA_VERSION agent.dockerfile \
    --build-arg MAVEN_MAJOR_VERSION=3 --build-arg PAYARA_VERSION=5
docker_build flowlogix/jenkins-agent:m4-p5-jdk$JAVA_VERSION agent.dockerfile \
    --build-arg MAVEN_MAJOR_VERSION=4 --build-arg PAYARA_VERSION=5
docker_build flowlogix/payara-full:$PAYARA_5_VERSION-jdk$JAVA_VERSION payara-alpine.dockerfile \
--build-arg PAYARA_VERSION=5
docker_push_tag flowlogix/payara-full $PAYARA_5_VERSION-jdk$JAVA_VERSION 5-latest
