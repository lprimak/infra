#!/bin/zsh -pl

source ~/.zshrc

ulimit -n 131072
sdk use java 8.0.332.fx-zulu
exec $HOME/apps/sonatype-nexus/current/bin/nexus run
