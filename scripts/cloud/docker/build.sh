#!/bin/sh

SCRIPT_DIR=`dirname "$0"`

exports_dir=$SCRIPT_DIR/context/exports
mkdir -p $exports_dir

for raw_dscr in \
infra/scripts/payara/download-payara.sh \
infra/scripts/cloud/downloads/geckodriver.sh
do
  [ -f ~/$raw_dscr ] && dscr=~/$raw_dscr
  [ -f ~/dev/$raw_dscr  ] && dscr=~/dev/$raw_dscr
  cp -p $dscr $SCRIPT_DIR/context/
done

docker build -t maven-builder context -f $SCRIPT_DIR/builders/Dockerfile.maven
docker build -t payara-builder context -f $SCRIPT_DIR/builders/Dockerfile.payara

$SCRIPT_DIR/cache.sh maven-builder

container=$(docker create payara-builder)
docker cp -q $container:/var/build/payara.tar.gz $exports_dir
docker cp -q $container:/var/build/maven.tar.gz $exports_dir
docker rm $container > /dev/null
docker rmi maven-builder > /dev/null
docker rmi payara-builder > /dev/null

cp $SCRIPT_DIR/agent/*.build $SCRIPT_DIR/context/
docker buildx build --platform linux/arm64,linux/amd64 context \
-t lprimak/jenkins-agent-maven4 -f agent/Dockerfile --push
