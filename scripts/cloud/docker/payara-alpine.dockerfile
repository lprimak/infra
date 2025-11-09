# syntax = devthefuture/dockerfile-x
ARG JAVA_VERSION=21
FROM azul/zulu-openjdk-alpine:${JAVA_VERSION}-jre-latest

RUN apk add --no-cache tini
INCLUDE payara.dockerfile
INCLUDE user-build.dockerfile

ENTRYPOINT ["/sbin/tini", "--"]
