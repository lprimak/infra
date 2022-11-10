#!/bin/zsh -l

export LC_ALL=C
export PGDATA=~/var/postgres

pg_ctl start

function shutdown() {
    pg_ctl stop
    exit 0
}
trap shutdown SIGTERM
while true; do
    sleep 86400 &
    wait $!
done
