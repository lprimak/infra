# syntax = devthefuture/dockerfile-x
ARG JAVA_VERSION
FROM azul/zulu-openjdk-alpine:${JAVA_VERSION}-latest

ARG MAVEN_MAJOR_VERSION
ARG MAVEN_VERSION
ARG BASE_URL=https://dlcdn.apache.org/maven/maven-${MAVEN_MAJOR_VERSION}/${MAVEN_VERSION}/binaries

RUN apk --update --no-cache add curl
RUN mkdir -p /usr/share/maven /var/build && chmod a+rwx /var/build \
 && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
 && tar xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && tar zcf /var/build/maven.tar.gz -C /usr/share maven \
 && rm /tmp/apache-maven.tar.gz && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
INCLUDE java-options.dockerfile
