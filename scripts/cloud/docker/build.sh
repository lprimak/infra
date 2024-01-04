#!/bin/sh

SCRIPT_DIR=`dirname "$0"`

[ -z "${FL_IS_BUILD_IMAGE}" ] && echo "Must be running in a docker container" && exit 1

. $SCRIPT_DIR/versions
. $SCRIPT_DIR/common/functions.sh

exports_dir=$SCRIPT_DIR/context/exports
rm -rf $SCRIPT_DIR/context
mkdir -p $exports_dir

for raw_dscr in \
infra/scripts/payara/download-payara.sh \
infra/scripts/payara/payara-download/pom.xml \
infra/scripts/cloud/docker/_builders/geckodriver.sh
do
  [ -f ~/$raw_dscr ] && dscr=~/$raw_dscr
  [ -f ~/dev/$raw_dscr  ] && dscr=~/dev/$raw_dscr
  cp -p $dscr $SCRIPT_DIR/context/
done
cp $SCRIPT_DIR/common/*.dockerfile $SCRIPT_DIR/context/

docker login
echo "Creating Maven Builders"
docker build -t maven-3-builder $SCRIPT_DIR/context --build-arg MAVEN_MAJOR_VERSION=3 \
    --build-arg MAVEN_VERSION=$MAVEN_3_VERSION -f $SCRIPT_DIR/_builders/maven.dockerfile
docker build -t maven-4-builder $SCRIPT_DIR/context --build-arg MAVEN_MAJOR_VERSION=4 \
    --build-arg MAVEN_VERSION=$MAVEN_4_VERSION -f $SCRIPT_DIR/_builders/maven.dockerfile

echo "Creating Payara Builders"
docker build -t payara-5-builder --build-arg PAYARA_VERSION=$PAYARA_5_VERSION \
    $SCRIPT_DIR/context -f $SCRIPT_DIR/_builders/payara.dockerfile
docker build -t payara-6-builder --build-arg PAYARA_VERSION=$PAYARA_6_VERSION \
    $SCRIPT_DIR/context -f $SCRIPT_DIR/_builders/payara.dockerfile
docker build -t payara-default-domain $SCRIPT_DIR/context -f $SCRIPT_DIR/_builders/payara-domain.dockerfile

echo "Caching maven reporitory"
$SCRIPT_DIR/_builders/cache.sh maven-4-builder

echo "Copying built products to $exports_dir"
copy_export payara-6-builder payara payara-6
copy_export payara-5-builder payara payara-5
copy_export payara-default-domain default-domain default-domain
copy_export maven-3-builder maven maven-3
copy_export maven-4-builder maven maven-4
echo "Finished copying built products"

docker_build lprimak/jenkins-agent-maven4 agent.dockerfile 4 6
docker_build lprimak/jenkins-master agent-master.dockerfile 4 6
docker_build lprimak/payara-full payara.dockerfile 4 6
