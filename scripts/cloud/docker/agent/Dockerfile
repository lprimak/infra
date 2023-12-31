# syntax = devthefuture/dockerfile-x
FROM azul/zulu-openjdk-alpine:21-latest

RUN apk --update --no-cache add bash docker-cli git openssh-client firefox curl coreutils sudo

INCLUDE maven.build
INCLUDE payara.build
INCLUDE firefox.build
INCLUDE user.build

RUN mkdir -p .m2/repository
RUN mkdir -p var/jenkins
COPY --chown=flowlogix:flowlogix exports/repositor[y] .m2/repository/

CMD ["sh", "-l"]
