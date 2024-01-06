[ -z "${FL_IS_BUILD_IMAGE}" ] && echo "Must be running in a docker container" && exit 1
. $SCRIPT_DIR/versions

function setup() {
    exports_dir=$SCRIPT_DIR/context/exports
    rm -rf $SCRIPT_DIR/context
    mkdir -p $exports_dir

    for raw_dscr in \
    infra/scripts/payara/download-payara.sh \
    infra/scripts/payara/payara-download/pom.xml \
    infra/scripts/cloud/docker/_builders/geckodriver.sh \
    infra/scripts/cloud/docker/_builders/install-docker.sh
    do
      [ -f ~/$raw_dscr ] && dscr=~/$raw_dscr
      [ -f ~/dev/$raw_dscr  ] && dscr=~/dev/$raw_dscr
      cp -p $dscr $SCRIPT_DIR/context/
    done
    cp $SCRIPT_DIR/common/*.dockerfile $SCRIPT_DIR/context/
}

function create_maven_builders() {
    echo "Creating Maven Builders"
    docker build -t maven-3-builder $SCRIPT_DIR/context --build-arg MAVEN_MAJOR_VERSION=3 \
        --build-arg MAVEN_VERSION=$MAVEN_3_VERSION -f $SCRIPT_DIR/_builders/maven.dockerfile
    docker build -t maven-4-builder $SCRIPT_DIR/context --build-arg MAVEN_MAJOR_VERSION=4 \
        --build-arg MAVEN_VERSION=$MAVEN_4_VERSION -f $SCRIPT_DIR/_builders/maven.dockerfile
}

function create_payara_builders() {
    echo "Creating Payara Builders"
    docker build -t payara-5-builder --build-arg PAYARA_VERSION=$PAYARA_5_VERSION \
        $SCRIPT_DIR/context -f $SCRIPT_DIR/_builders/payara.dockerfile
    docker build -t payara-6-builder --build-arg PAYARA_VERSION=$PAYARA_6_VERSION \
        $SCRIPT_DIR/context -f $SCRIPT_DIR/_builders/payara.dockerfile
    docker build -t payara-default-domain $SCRIPT_DIR/context -f $SCRIPT_DIR/_builders/payara-domain.dockerfile
}

function copy_export() {
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
    copy_export payara-6-builder payara payara-6
    copy_export payara-5-builder payara payara-5
    copy_export payara-default-domain default-domain default-domain
    echo "Finished copying built products"
}

function docker_build() {
    local tag=$1
    local ctx=$2
    shift;shift
    docker buildx build --platform linux/arm64,linux/amd64 $SCRIPT_DIR/context \
        -t $tag -f $SCRIPT_DIR/$ctx --build-arg GECKODRIVER_VERSION=$GECKODRIVER_VERSION --push $@
}
