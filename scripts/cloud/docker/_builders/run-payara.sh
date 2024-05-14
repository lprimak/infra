#!/bin/sh
# Use only one JVM to run Payara
exec $(asadmin start-domain --debug -v --dry-run $PAYARA_ARGS \
| fgrep -v "Dump of JVM Invocation line" \
| sed -n -e '2,/^$/p') < /dev/null
