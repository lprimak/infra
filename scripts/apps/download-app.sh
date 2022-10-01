#!/bin/zsh -p

exec curl --netrc-file $HOME/var/secrets/jenkins-auth "$1" --output "$2"

