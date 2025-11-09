#!/bin/zsh -l

ssh -N web1 exit
sshpass -p 'vagrant' ssh -N local-containers exit
