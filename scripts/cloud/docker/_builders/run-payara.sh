#!/bin/sh
# Use only one JVM to run Payara
exec $(asadmin start-domain -v --dry-run $PAYARA_ARGS \
| fgrep -v -e "Dump of JVM Invocation line" \
-e "Unable to create a system terminal" \
-e "JVM invocation command line") < /dev/null
