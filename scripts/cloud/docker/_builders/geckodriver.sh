#!/bin/bash -p

if [ "$2" = "arm64" ]; then
  TARGET_ARCH="-aarch64"
elif [ "$2" = "amd64" ]; then
  TARGET_ARCH="64"
else
  TARGET_ARCH="unknown"
fi

exec curl -fsSL -o /tmp/geckodriver.tar.gz $1$TARGET_ARCH.tar.gz
