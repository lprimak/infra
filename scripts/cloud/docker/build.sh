#!/bin/bash -p

SCRIPT_DIR=`dirname "$0"`

. $SCRIPT_DIR/common/functions.sh
setup

docker login
create_maven_builders
create_payara_builders
$SCRIPT_DIR/_builders/cache.sh maven-4-builder

export_maven_from_builders
export_payara_from_builders 6

docker_build lprimak/jenkins-agent:m4-p6-jdk$JAVA_VERSION agent.dockerfile \
    --build-arg MAVEN_MAJOR_VERSION=4 --build-arg PAYARA_VERSION=6
docker_push_latest lprimak/jenkins-agent m4-p6-jdk$JAVA_VERSION

docker_build lprimak/payara-full:$PAYARA_6_VERSION-jdk$JAVA_VERSION payara.dockerfile --build-arg PAYARA_VERSION=6
docker_push_latest lprimak/payara-full $PAYARA_6_VERSION-jdk$JAVA_VERSION

docker_build lprimak/jenkins-agent:m3-p6-jdk$JAVA_VERSION agent.dockerfile \
    --build-arg MAVEN_MAJOR_VERSION=3 --build-arg PAYARA_VERSION=6
