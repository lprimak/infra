#!/bin/sh

SCRIPT_DIR=`dirname "$0"`

exports_dir=$SCRIPT_DIR/context/exports
mkdir -p $exports_dir

for raw_dscr in \
infra/scripts/payara/download-payara.sh \
infra/scripts/payara/payara-download/pom.xml \
infra/scripts/cloud/downloads/geckodriver.sh
do
  [ -f ~/$raw_dscr ] && dscr=~/$raw_dscr
  [ -f ~/dev/$raw_dscr  ] && dscr=~/dev/$raw_dscr
  cp -p $dscr $SCRIPT_DIR/context/
done

docker login
docker build -t maven-builder $SCRIPT_DIR/context -f $SCRIPT_DIR/builders/Dockerfile.maven
docker build -t payara-builder $SCRIPT_DIR/context -f $SCRIPT_DIR/builders/Dockerfile.payara

$SCRIPT_DIR/cache.sh maven-builder

container=$(docker create payara-builder)
docker cp -q $container:/var/build/payara-6.tar.gz $exports_dir
docker cp -q $container:/var/build/payara-5.tar.gz $exports_dir
docker cp -q $container:/var/build/default-domain.tar.gz $exports_dir
docker cp -q $container:/var/build/maven-3.tar.gz $exports_dir
docker cp -q $container:/var/build/maven-4.tar.gz $exports_dir
docker rm $container > /dev/null
docker rmi maven-builder > /dev/null
docker rmi payara-builder > /dev/null

cp $SCRIPT_DIR/common/*.build $SCRIPT_DIR/context/

docker buildx build --platform linux/arm64,linux/amd64 $SCRIPT_DIR/context \
-t lprimak/jenkins-agent-maven4 -f $SCRIPT_DIR/agent/Dockerfile --push
docker buildx build --platform linux/arm64,linux/amd64 $SCRIPT_DIR/context \
-t lprimak/jenkins-master -f $SCRIPT_DIR/agent-master/Dockerfile --push
docker buildx build --platform linux/arm64,linux/amd64 $SCRIPT_DIR/context \
-t lprimak/payara-full -f $SCRIPT_DIR/payara/Dockerfile --push
