# syntax = devthefuture/dockerfile-x
ARG JAVA_VERSION=21
FROM azul/zulu-openjdk:${JAVA_VERSION}-jre-latest

RUN apt-get update && apt-get install -y tini
INCLUDE payara.dockerfile
INCLUDE user-build-ubuntu.dockerfile

ENTRYPOINT ["/usr/bin/tini", "--"]
