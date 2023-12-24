FROM azul/zulu-openjdk-alpine:21-latest

ARG MAVEN_3_VERSION=3.9.6
ARG MAVEN_4_VERSION=4.0.0-alpha-10
ARG BASE_URL_3=https://apache.osuosl.org/maven/maven-3/${MAVEN_3_VERSION}/binaries
ARG BASE_URL_4=https://apache.osuosl.org/maven/maven-4/${MAVEN_4_VERSION}/binaries

RUN apk --update --no-cache add curl
RUN mkdir -p /usr/share/maven /usr/share/maven3 /var/build && chmod a+rwx /var/build \
 && curl -fsSL -o /tmp/apache-maven-3.tar.gz ${BASE_URL_3}/apache-maven-${MAVEN_3_VERSION}-bin.tar.gz \
 && curl -fsSL -o /tmp/apache-maven-4.tar.gz ${BASE_URL_4}/apache-maven-${MAVEN_4_VERSION}-bin.tar.gz \
 && tar -xzf /tmp/apache-maven-3.tar.gz -C /usr/share/maven3 --strip-components=1 \
 && tar -xzf /tmp/apache-maven-4.tar.gz -C /usr/share/maven --strip-components=1 \
 && tar zcf /var/build/maven-3.tar.gz -C /usr/share maven3 \
 && tar zcf /var/build/maven-4.tar.gz -C /usr/share maven \
 && rm /tmp/apache-maven-3.tar.gz /tmp/apache-maven-4.tar.gz \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
