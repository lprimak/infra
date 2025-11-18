# syntax = devthefuture/dockerfile-x
ARG JAVA_VERSION=21
FROM azul/zulu-openjdk-alpine:${JAVA_VERSION}-latest

RUN apk --update --no-cache add bash docker-cli git openssh-client firefox curl coreutils sudo tini

INCLUDE maven-build.dockerfile
INCLUDE payara-build.dockerfile
INCLUDE user-build.dockerfile

RUN mkdir -p .m2/repository var/jenkins
COPY --chown=$USER:$USER exports/repositor[y] .m2/repository/
COPY --chown=$USER:$USER agent-maven-settings.xml .m2/settings.xml
COPY --chown=$USER:$USER agent-maven.properties .m2/maven-user.properties

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["sh", "-l"]
