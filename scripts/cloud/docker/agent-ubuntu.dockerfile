# syntax = devthefuture/dockerfile-x
ARG JAVA_VERSION=21
FROM azul/zulu-openjdk:${JAVA_VERSION}-latest

RUN apt-get update && apt-get install -y git openssh-client curl coreutils tini

INCLUDE maven-build.dockerfile
INCLUDE payara-build.dockerfile
INCLUDE user-build-ubuntu.dockerfile

RUN mkdir -p .m2/repository var/jenkins
COPY --chown=$USER:$USER exports/repositor[y] .m2/repository/
COPY --chown=$USER:$USER agent-maven-settings.xml .m2/settings.xml
COPY --chown=$USER:$USER agent-maven.properties .m2/maven-user.properties

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash", "-l"]
