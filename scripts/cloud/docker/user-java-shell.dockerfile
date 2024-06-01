# syntax = devthefuture/dockerfile-x
ARG JAVA_VERSION
FROM azul/zulu-openjdk-alpine:${JAVA_VERSION}-latest

RUN apk --update --no-cache add bash git openssh-client curl coreutils sudo

INCLUDE user-build.dockerfile
RUN mkdir -p var/

CMD ["sh", "-l"]
