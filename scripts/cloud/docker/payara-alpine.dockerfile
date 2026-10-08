# syntax = devthefuture/dockerfile-x
ARG JAVA_VERSION=21
FROM azul-zulu:${JAVA_VERSION}-jre-alpine

RUN apk add --no-cache tini
INCLUDE payara.dockerfile
INCLUDE user-build.dockerfile

ENTRYPOINT ["/sbin/tini", "--"]
