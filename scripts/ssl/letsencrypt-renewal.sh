#!/bin/zsh -l

SCRIPT_DIR=`dirname "$0"`

exec $SCRIPT_DIR/letsencrypt-common.sh renew -q --deploy-hook $SCRIPT_DIR/letsencrypt-after-renewal.sh "$@"
