# syntax = devthefuture/dockerfile-x
ARG JAVA_VERSION=21
FROM azul-zulu:${JAVA_VERSION}-jre-alpine

RUN apk --update --no-cache add bash docker-cli git openssh-client curl coreutils

INCLUDE user-build.dockerfile
RUN mkdir -p var/jenkins

CMD ["sh", "-l"]
