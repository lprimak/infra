# syntax = devthefuture/dockerfile-x
ARG JAVA_VERSION=21
FROM azul-zulu:${JAVA_VERSION}-jdk-alpine

RUN apk --update --no-cache add bash git openssh-client curl coreutils sudo

INCLUDE user-build.dockerfile
RUN mkdir -p var/

CMD ["sh", "-l"]
