#!/bin/bash -p

# Google search that resulted in this script: jenkins install plugins from script

# This script is taken from https://gist.github.com/micw/e80d739c6099078ce0f3
# Example Run: $ ./install-plugins.sh `cat plugin-list.txt`

# Modified to:
# - Save files as .JPI instead of .HPI to conform to current version of Jenkins
# - Using "without optionals" variant of dependencies
# - Removed permissions check

set -e

if [ $# -eq 0 ]; then
  echo "USAGE: $0 plugin1 plugin2 ..."
  echo "Example: $0 \`cat plugin-list.txt\`"
  exit 1
fi

plugin_dir=${HOME}/var/jenkins/plugins

mkdir -p $plugin_dir

installPlugin() {
  if [ -f ${plugin_dir}/${1}.hpi -o -f ${plugin_dir}/${1}.jpi ]; then
    if [ "$2" == "1" ]; then
      return 1
    fi
    echo "Skipped: $1 (already installed)"
    return 0
  else
    echo "Installing: $1"
    curl -L --silent --output ${plugin_dir}/${1}.jpi  https://updates.jenkins-ci.org/latest/${1}.hpi
    return 0
  fi
}

for plugin in $*
do
    installPlugin "$plugin"
done

changed=1
maxloops=100

while [ "$changed"  == "1" ]; do
  echo "Check for missing dependecies ..."
  if  [ $maxloops -lt 1 ] ; then
    echo "Max loop count reached - probably a bug in this script: $0"
    exit 1
  fi
  ((maxloops--))
  changed=0
  for f in ${plugin_dir}/*.jpi ; do
    # without optionals
    deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | gsed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | grep -v "resolution:=optional" | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
    # with optionals
    #deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
    for plugin in $deps; do
      installPlugin "$plugin" 1 && changed=1
    done
  done
done

echo "all done"
