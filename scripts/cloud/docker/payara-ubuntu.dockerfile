# syntax = devthefuture/dockerfile-x
ARG JAVA_VERSION=21
FROM azul-zulu:${JAVA_VERSION}-jre

RUN apt-get update && apt-get install -y tini
INCLUDE payara.dockerfile
INCLUDE user-build-ubuntu.dockerfile

ENTRYPOINT ["/usr/bin/tini", "--"]
