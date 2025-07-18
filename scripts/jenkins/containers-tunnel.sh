#!/bin/zsh -l

ssh -N containers exit
sshpass -p 'vagrant' ssh -N local-containers exit
