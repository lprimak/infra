#!/bin/zsh -p

exec ssh -N containers exit
exec ssh -N local-containers exit
