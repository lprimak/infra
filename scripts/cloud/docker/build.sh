#!/bin/bash -p

SCRIPT_DIR=`dirname "$0"`

[ -z "${FL_IS_BUILD_IMAGE}" ] && echo "Must be running in a docker container" && exit 1

. $SCRIPT_DIR/common/functions.sh

setup

docker login
create_maven_builders
create_payara_builders
echo "Caching maven repository"
$SCRIPT_DIR/_builders/cache.sh maven-4-builder

export_maven_from_builders
export_payara_from_builders

docker_build lprimak/jenkins-agent-maven4 agent.dockerfile \
    --build-arg MAVEN_MAJOR_VERSION=4 --build-arg PAYARA_VERSION=6
docker_build lprimak/payara-full payara.dockerfile --build-arg PAYARA_VERSION=6
