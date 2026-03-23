#!/bin/zsh

SCRIPT_DIR=$(dirname "$0")

[ "$#" -lt 4 ] && { echo "Usage: $0 <backend> <http> <https> <blocked_ips_file>"; exit 1; }

if [ -d "$HOME/var/haproxy" ] ; then
    HAPROXY_DIR="$HOME/var/haproxy"
    TEMPLATE_DIR="$SCRIPT_DIR"/../../etc/haproxy
    else
    HAPROXY_DIR="/etc/haproxy"
    TEMPLATE_DIR="/etc/haproxy"
fi

# awk 1 concatenates files (sorted by glob) and ensures newlines between them
awk 1 "$TEMPLATE_DIR"/templates/*.template | sed \
  -e "s|__DEFAULT_BACKEND__|$1|g" \
  -e "s|__HTTP_PORT__|$2|g" \
  -e "s|__HTTPS_PORT__|$3|g" \
  -s "s|__BLOCKED_IPS_CONFIG__|$4|g" \
  > "$HAPROXY_DIR/frontend.cfg"

echo "Generated $HAPROXY_DIR/frontend.cfg"
