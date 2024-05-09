#!/bin/sh
# Use only one JVM to run Payara
exec $(asadmin start-domain --debug -v --dry-run $PAYARA_ARGS | sed -n -e '3,/^$/p') < /dev/null
