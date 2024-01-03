#!/bin/sh

SCRIPT_DIR=`dirname "$0"`

[ -z "${FL_IS_BUILD_IMAGE}" ] && echo "Must be running in a docker container" && exit 1

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
echo "Creating Maven Builder"
docker build -t maven-builder $SCRIPT_DIR/context -f $SCRIPT_DIR/_builders/maven.dockerfile
echo "Creating Payara Builder"
docker build -t payara-builder $SCRIPT_DIR/context -f $SCRIPT_DIR/_builders/payara.dockerfile

echo "Caching maven reporitory"
$SCRIPT_DIR/_builders/cache.sh maven-builder

echo "Copying built products to $exports_dir"
container=$(docker create payara-builder)
docker cp -q $container:/var/build/payara-6.tar.gz $exports_dir
docker cp -q $container:/var/build/payara-5.tar.gz $exports_dir
docker cp -q $container:/var/build/default-domain.tar.gz $exports_dir
docker cp -q $container:/var/build/maven-3.tar.gz $exports_dir
docker cp -q $container:/var/build/maven-4.tar.gz $exports_dir
docker rm $container > /dev/null
docker rmi maven-builder > /dev/null
docker rmi payara-builder > /dev/null
echo "Finished copying built products"

function docker_build() {
docker buildx build --platform linux/arm64,linux/amd64 $SCRIPT_DIR/context \
    -t $1 -f $SCRIPT_DIR/$2 --push
}

docker_build lprimak/jenkins-agent-maven4 agent.dockerfile
docker_build lprimak/jenkins-master agent-master.dockerfile
docker_build lprimak/payara-full payara.dockerfile
