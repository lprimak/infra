# syntax = devthefuture/dockerfile-x
FROM azul/zulu-openjdk-alpine:21-latest

RUN apk --update --no-cache add git openssh-client firefox curl

INCLUDE maven.build
INCLUDE payara.build
INCLUDE firefox.build
INCLUDE user.build

RUN mkdir -p .m2/repository
COPY --chown=flowlogix:flowlogix exports/repositor[y] .m2/repository/

CMD ["sh", "-l"]
