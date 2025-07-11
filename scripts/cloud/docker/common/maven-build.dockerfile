# syntax = devthefuture/dockerfile-x
ARG MAVEN_MAJOR_VERSION

COPY exports/maven-${MAVEN_MAJOR_VERSION}.tar.gz /tmp/maven.tar.gz
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
  && tar zxf /tmp/maven.tar.gz -C /usr/share && rm -f /tmp/maven.tar.gz
ENV MAVEN_HOME /usr/share/maven
INCLUDE java-options.dockerfile
