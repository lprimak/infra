# syntax = devthefuture/dockerfile-x
FROM alpine

RUN apk --update --no-cache add bash git openssh-client curl coreutils sudo

INCLUDE user-build.dockerfile
RUN mkdir -p var/

CMD ["sh", "-l"]
