#!/bin/zsh

SCRIPT_DIR=$(dirname "$0")

$SCRIPT_DIR/configure-haproxy.sh payara 16380 16443
$HOME/apps/haproxy/current/bin/haproxy -- $HOME/infra/etc/haproxy/config \
$HOME/infra/etc/haproxy/sites/nova-global.cfg $HOME/var/haproxy/frontend.cfg
