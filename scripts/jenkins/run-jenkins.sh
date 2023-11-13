#!/bin/zsh -l

source ~/.zshrc
SCRIPT_DIR=`dirname "$0"`

unset AS_ADMIN_USER
unset AS_ADMIN_PASSWORDFILE

jenkins_bin=$HOME/apps/jenkins/current

$SCRIPT_DIR/containers-tunnel.sh

exec java -Xmx1g -XX:+UseZGC -XX:+ZGenerational \
--add-opens java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED \
--add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.util.concurrent=ALL-UNNAMED \
--add-opens java.base/sun.util.calendar=ALL-UNNAMED \
-DJENKINS_HOME=$HOME/var/jenkins \
-Dhudson.security.ArtifactsPermission=true -DBLUEOCEAN_FEATURE_AUTOFAVORITE_ENABLED=false \
-jar $jenkins_bin/jenkins.war --enable-future-java \
--httpPort=8088 --httpsPort=-1 --http2Port=-1 \
--extraLibFolder=$jenkins_bin "$@"
