# syntax = devthefuture/dockerfile-x
ARG JAVA_VERSION
FROM azul/zulu-openjdk-alpine:${JAVA_VERSION}-latest

RUN apk --update --no-cache add bash docker-cli git openssh-client firefox curl coreutils sudo

INCLUDE maven-build.dockerfile
INCLUDE payara-build.dockerfile
INCLUDE firefox-build.dockerfile
INCLUDE user-build.dockerfile

RUN mkdir -p .m2/repository
RUN mkdir -p var/jenkins
COPY --chown=flowlogix:flowlogix exports/repositor[y] .m2/repository/

CMD ["sh", "-l"]
