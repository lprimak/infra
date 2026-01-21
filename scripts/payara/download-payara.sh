#!/bin/zsh

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version> [distribution-package]"
    exit 1
fi

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

payara_version=$1
distribution_package=$2
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

mkdir -p $temp_dir/jdbc $temp_dir/updates
cd $temp_dir

maven_flags="-B -C -ntp -q"

if [ ! -z "$distribution_package" ]; then
    distribution_package="-Dpayara.distributions.groupId=$distribution_package"
fi

mvn $(echo $maven_flags) -f $SCRIPT_DIR/payara-download \
-Dpayara-version=${payara_version} $distribution_package \
-Dtemp-dir=$temp_dir

sdk_use_jdk=""
domain_suffix=""
if [ -d $temp_dir/payara5 ]; then
    versioned_dir=payara5
    [ -d "$HOME/Applications/payara" ] && domain_suffix="-p5"
    sdk_use_jdk="[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] \
        && source "${HOME}/.sdkman/bin/sdkman-init.sh" \
        && sdk use java 21.0.9-zulu"
fi
if [ -d $temp_dir/payara6 ]; then
    versioned_dir=payara6
fi
if [ -d $temp_dir/payara7 ]; then
    versioned_dir=payara7
    [ -d "$HOME/Applications/payara" ] && domain_suffix="-p7"

    mv $temp_dir/tyrus* $temp_dir/updates
    mv $temp_dir/org.eclipse.persistence.core.* $temp_dir/updates
    mv $temp_dir/org.eclipse.persistence.jpa.* $temp_dir/updates
fi

mv $temp_dir/post* $temp_dir/sqlite* $temp_dir/jdbc
mv $temp_dir/asm* $temp_dir/updates
mv $temp_dir/org.eclipse.persistence.asm* $temp_dir/updates

mv $temp_dir/jdbc/* $temp_dir/${versioned_dir}/glassfish/lib
modules_dir=$temp_dir/${versioned_dir}/glassfish/modules
mv $temp_dir/updates/* $modules_dir

mv $temp_dir/${versioned_dir} $target_dir
rm -rf $temp_dir
rm -rf $target_dir/META-INF

if [ -d ${HOME}/apps/payara ]; then
    cat << EOF >> $target_dir/glassfish/config/asenv.conf

    export SDKMAN_DIR AS_ADMIN_PORT

    # Override Defaults
    SDKMAN_DIR="${HOME}/.sdkman"
    AS_ADMIN_PORT=1148
EOF
fi

cat << EOF >> $target_dir/glassfish/config/asenv.conf
    AS_DEF_DOMAINS_PATH="\${HOME}/var/payara-domains${domain_suffix}"
    AS_DEF_NODES_PATH="\${HOME}/var/payara-nodes${domain_suffix}"
    AS_EXTRA_JAVA_OPTS="--enable-native-access=ALL-UNNAMED"
    $sdk_use_jdk
EOF
