#!/bin/zsh -l

source ~/.zshrc

ulimit -n 131072
sdk use java 8.0.382.fx-zulu
exec $HOME/apps/sonatype-nexus/current/bin/nexus run
