# syntax = devthefuture/dockerfile-x
FROM azul/zulu-openjdk-alpine:21-latest

INCLUDE payara.build
RUN apk add --no-cache tini
INCLUDE user.build

COPY --chown=$USER exports/default-domain.tar.gz /tmp
RUN mkdir -p $HOME/var/payara-domains && tar zxf /tmp/default-domain.tar.gz -C $HOME/var/payara-domains/ \
    && rm -f /tmp/default-domain.tar.gz

EXPOSE 4848 9009 8080 8181

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["sh", "-l", "-c", "asadmin start-domain -v"]
