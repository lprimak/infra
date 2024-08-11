#!/bin/zsh -l

source ~/.zshrc

ulimit -n 131072
sdk use java 17.0.12-zulu
exec $HOME/apps/nexus/current/bin/nexus run
