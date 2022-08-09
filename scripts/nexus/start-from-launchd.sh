#!/bin/zsh -pl

source ~/.zshrc

ulimit -n 131072
sdk use java 8.0.345.fx-zulu
exec $HOME/apps/sonatype-nexus/current/bin/nexus run
