#!/bin/zsh -l

source ~/.zshrc

ulimit -n 131072
sdk use java 11.0.24-zulu
exec $HOME/apps/nexus/current/bin/nexus run
