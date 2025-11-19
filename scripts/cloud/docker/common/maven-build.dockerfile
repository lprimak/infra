# syntax = devthefuture/dockerfile-x
ARG MAVEN_MAJOR_VERSION

ADD --unpack=true exports/maven-${MAVEN_MAJOR_VERSION}.tar.gz /usr/share
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME=/usr/share/maven
INCLUDE java-options.dockerfile
