#!/bin/zsh

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi
payara_version=$1
payara_basedir=${HOME}/apps/payara
if [ ! -d ${HOME}/apps/payara ]; then
    payara_basedir=$PWD
fi
temp_dir=$payara_basedir/temp-${payara_version}
target_dir=$payara_basedir/payara-${payara_version}

if [ -d $target_dir ]; then
    echo "$target_dir already exists"
    exit 1
fi

maven_flags="-B -C -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn"

mvn $(echo $maven_flags) dependency:unpack -Dartifact=fish.payara.distributions:payara:${payara_version}:zip \
    -Dproject.basedir=$temp_dir -DoutputDirectory=$temp_dir -DoverWrite=false

mvn $(echo $maven_flags) dependency:copy -Dartifact=org.postgresql:postgresql:LATEST:jar \
    -Dproject.basedir=$temp_dir -DoutputDirectory=$temp_dir/pgjdbc -DoverWrite=false

mvn $(echo $maven_flags) dependency:copy -Dartifact=org.ow2.asm:asm:LATEST:jar \
    -Dproject.basedir=$temp_dir -DoutputDirectory=$temp_dir/updates -DoverWrite=false -Dmdep.stripVersion=true
mvn $(echo $maven_flags) dependency:copy -Dartifact=org.ow2.asm:asm-analysis:LATEST:jar \
    -Dproject.basedir=$temp_dir -DoutputDirectory=$temp_dir/updates -DoverWrite=false -Dmdep.stripVersion=true
mvn $(echo $maven_flags) dependency:copy -Dartifact=org.ow2.asm:asm-commons:LATEST:jar \
    -Dproject.basedir=$temp_dir -DoutputDirectory=$temp_dir/updates -DoverWrite=false -Dmdep.stripVersion=true
mvn $(echo $maven_flags) dependency:copy -Dartifact=org.ow2.asm:asm-tree:LATEST:jar \
    -Dproject.basedir=$temp_dir -DoutputDirectory=$temp_dir/updates -DoverWrite=false -Dmdep.stripVersion=true
mvn $(echo $maven_flags) dependency:copy -Dartifact=org.ow2.asm:asm-util:LATEST:jar \
    -Dproject.basedir=$temp_dir -DoutputDirectory=$temp_dir/updates -DoverWrite=false -Dmdep.stripVersion=true

if [ -d $temp_dir/payara5 ]; then
    versioned_dir=payara5
fi
if [ -d $temp_dir/payara6 ]; then
    versioned_dir=payara6
fi

mv $temp_dir/pgjdbc/* $temp_dir/${versioned_dir}/glassfish/lib
module_updates_dir=$temp_dir/${versioned_dir}/glassfish/modules/updates
mkdir -p $module_updates_dir
mv $temp_dir/updates/* $module_updates_dir

mv $temp_dir/${versioned_dir} $target_dir
rm -rf $temp_dir

if [ -d ${HOME}/apps/payara ]; then
    cat << EOF >> $target_dir/glassfish/config/asenv.conf

    # Override Defaults
    export SDKMAN_DIR="${HOME}/.sdkman"
    [[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
    # sdk use java 11.0.14-zulu
    AS_DEF_DOMAINS_PATH="\${HOME}/var/payara-domains"
    AS_DEF_NODES_PATH="\${HOME}/var/payara-nodes"
    export AS_ADMIN_PORT=1148
EOF

fi
