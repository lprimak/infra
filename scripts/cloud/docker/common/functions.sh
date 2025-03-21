[ -z "${FL_IS_BUILD_IMAGE}" ] && echo "Must be running in a docker container" && exit 1
. $SCRIPT_DIR/versions

function setup() {
    exports_dir=$SCRIPT_DIR/context/exports
    mkdir -p $exports_dir

    for raw_dscr in \
    infra/scripts/payara/download-payara.sh \
    infra/scripts/payara/payara-download/pom.xml \
    infra/scripts/cloud/docker/_builders/geckodriver.sh \
    infra/scripts/cloud/docker/_builders/install-docker.sh \
    infra/scripts/cloud/docker/_builders/agent-maven-settings.xml \
    infra/scripts/cloud/docker/_builders/agent-maven.properties \
    infra/scripts/cloud/docker/_builders/run-payara.sh
    do
      [ -f ~/$raw_dscr ] && dscr=~/$raw_dscr
      [ -f ~/dev/$raw_dscr  ] && dscr=~/dev/$raw_dscr
      cp -p $dscr $SCRIPT_DIR/context/
    done
    cp $SCRIPT_DIR/common/*.dockerfile $SCRIPT_DIR/context/
}

function create_maven_builders() {
    if [ -f $exports_dir/maven-3.tar.gz ]; then
        echo "Maven Artifacts already created"
        return 0
    else
        echo "Creating Maven Builders"
    fi
    docker build -t maven-3-builder $SCRIPT_DIR/context --build-arg JAVA_VERSION=$JAVA_VERSION \
        --build-arg MAVEN_MAJOR_VERSION=3 --build-arg MAVEN_VERSION=$MAVEN_3_VERSION \
        -f $SCRIPT_DIR/_builders/maven.dockerfile
    docker build -t maven-4-builder $SCRIPT_DIR/context --build-arg JAVA_VERSION=$JAVA_VERSION \
        --build-arg MAVEN_MAJOR_VERSION=4 --build-arg MAVEN_VERSION=$MAVEN_4_VERSION \
        -f $SCRIPT_DIR/_builders/maven.dockerfile
}

function create_payara_builders() {
    if [ -z "$1" ]; then
        payara_major_version=6
    else
        payara_major_version=$1
    fi
    if [ -f $exports_dir/payara-${payara_major_version}.tar.gz ]; then
        echo "Payara Artifacts already created"
        return 0
    else
        docker images|grep -F maven-4-builder > /dev/null
        if [ $? -ne 0 ]; then
            rm -f $exports_dir/maven-3.tar.gz $exports_dir/maven-4.tar.gz
            create_maven_builders
        fi
        echo "Creating Payara Builders"
    fi
    payara_version_variable=PAYARA_${payara_major_version}_VERSION
    docker build -t payara-${payara_major_version}-builder --build-arg JAVA_VERSION=$JAVA_VERSION \
        --build-arg PAYARA_VERSION=$(eval echo \$$payara_version_variable) \
        --build-arg PAYARA_MAJOR_VERSION=$payara_major_version \
        --build-arg DISTRIBUTION_PACKAGE=$DISTRIBUTION_PACKAGE \
        $SCRIPT_DIR/context -f $SCRIPT_DIR/_builders/payara.dockerfile
    docker build -t payara-${payara_major_version}-default-domain $SCRIPT_DIR/context \
        --build-arg PAYARA_VERSION=$payara_major_version \
        --build-arg DISTRIBUTION_PACKAGE=$DISTRIBUTION_PACKAGE \
        -f $SCRIPT_DIR/_builders/payara-domain.dockerfile
}

function copy_export() {
    if [ -f $exports_dir/$3.tar.gz ]; then
        return 0
    fi
    local container=$(docker create $1)
    docker cp -q $container:/var/build/$2.tar.gz $exports_dir/$3.tar.gz
    docker rm $container
    docker rmi $1 > /dev/null
}

function export_maven_from_builders() {
    echo "Copying maven built products to $exports_dir"
    copy_export maven-3-builder maven maven-3
    copy_export maven-4-builder maven maven-4
}

function export_payara_from_builders() {
    echo "Copying payara built products to $exports_dir"
    copy_export payara-$1-builder payara payara-$1
    copy_export payara-$1-default-domain default-domain default-domain-payara-$1
    echo "Finished copying built products"
}

function docker_build() {
    local tag=$1
    local ctx=$2
    shift;shift
    docker buildx build --platform linux/arm64,linux/amd64 $SCRIPT_DIR/context \
        -t $tag -f $SCRIPT_DIR/$ctx --build-arg GECKODRIVER_VERSION=$GECKODRIVER_VERSION \
        --build-arg JAVA_VERSION=$JAVA_VERSION --push $@
}

function docker_push_tag() {
    docker tag $1:$2 $1:$3
    docker push $1:$3
}

function docker_push_latest() {
    docker_push_tag $1 $2 latest
}
