#!/bin/zsh -p

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi
payara_version=$1
temp_dir=${HOME}/apps/payara/temp-${payara_version}
target_dir=${HOME}/apps/payara/payara-${payara_version}

if [ -d $target_dir ]; then
    echo "$target_dir already exists"
    exit 1
fi

mvn dependency:unpack -Dartifact=fish.payara.distributions:payara:${payara_version}:zip \
    -Dproject.basedir=$temp_dir -DoutputDirectory=$temp_dir -DoverWrite=false

mv $temp_dir/payara5 $target_dir
rm -rf $temp_dir

cat << EOF >> $target_dir/glassfish/config/asenv.conf

# Override Defaults
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"
# sdk use java 11.0.14-zulu
AS_DEF_DOMAINS_PATH="\${HOME}/hope-website/payara-domains"
AS_DEF_NODES_PATH="\${HOME}/hope-website/payara-nodes"
export AS_ADMIN_PORT=1148
EOF
