# syntax = devthefuture/dockerfile-x
ARG JAVA_VERSION
FROM azul/zulu-openjdk-alpine:${JAVA_VERSION}-latest

INCLUDE payara-build.dockerfile
RUN apk add --no-cache tini
INCLUDE user-build.dockerfile

COPY --chown=$USER exports/default-domain.tar.gz /tmp
RUN mkdir -p $HOME/var/payara-domains && tar zxf /tmp/default-domain.tar.gz -C $HOME/var/payara-domains/ \
    && rm -f /tmp/default-domain.tar.gz

EXPOSE 4848 9009 8080 8181

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["sh", "-l", "-c", "asadmin start-domain -v"]
