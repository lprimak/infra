#!/bin/zsh

SCRIPT_DIR=$(dirname "$0")

[ "$#" -lt 3 ] && { echo "Usage: $0 <backend> <http> <https>"; exit 1; }

if [ -d "$HOME/var/haproxy" ] ; then
    HAPROXY_DIR="$HOME/var/haproxy"
    else
    HAPROXY_DIR="/etc/haproxy/conf.d"
fi

# awk 1 concatenates files (sorted by glob) and ensures newlines between them
awk 1 "$SCRIPT_DIR"/../../etc/haproxy/templates/*.template | sed \
  -e "s|__DEFAULT_BACKEND__|$1|g" \
  -e "s|__HTTP_PORT__|$2|g" \
  -e "s|__HTTPS_PORT__|$3|g" > "$HAPROXY_DIR/frontend.cfg"

echo "Generated $HAPROXY_DIR/frontend.cfg"
