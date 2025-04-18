#!/bin/zsh -l

source ~/.zshrc

ulimit -n 131072
sdk use java 17.0.15-zulu
export NEXUS_SECRETS_KEY_FILE=~/var/secrets/sonatype-nexus-keys
exec $HOME/apps/nexus/current/bin/nexus run
