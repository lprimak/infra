function copy_export() {
    local container=$(docker create $1)
    docker cp -q $container:/var/build/$2.tar.gz $exports_dir/$3.tar.gz
    docker rm $container
    docker rmi $1 > /dev/null
}

function docker_build() {
docker buildx build --platform linux/arm64,linux/amd64 $SCRIPT_DIR/context \
    -t $1 -f $SCRIPT_DIR/$2 --build-arg MAVEN_MAJOR_VERSION=$3 --build-arg PAYARA_VERSION=$4 \
    --build-arg GECKODRIVER_VERSION=$GECKODRIVER_VERSION --push
}
