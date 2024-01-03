# syntax = devthefuture/dockerfile-x
FROM azul/zulu-openjdk-alpine:21-latest

RUN apk --update --no-cache add bash docker-cli git openssh-client curl coreutils

INCLUDE user-build.dockerfile
RUN mkdir -p var/jenkins

CMD ["sh", "-l"]
