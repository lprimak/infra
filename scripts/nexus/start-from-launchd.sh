#!/bin/zsh -l

source ~/.zshrc

ulimit -n 131072
sdk use java 8.0.402-zulu
exec $HOME/apps/nexus/current/bin/nexus run
