# syntax = devthefuture/dockerfile-x
ARG PAYARA_VERSION
ARG USER=flowlogix
ARG HOME=/home/$USER

INCLUDE payara-build.dockerfile

COPY run-payara.sh /usr/share/payara/bin
COPY --chown=$USER exports/default-domain-payara-${PAYARA_VERSION}.tar.gz /tmp/default-domain.tar.gz
RUN mkdir -p $HOME/var/payara-domains && tar zxf /tmp/default-domain.tar.gz -C $HOME/var/payara-domains/ \
    && rm -f /tmp/default-domain.tar.gz

EXPOSE 4848 9009 8080 8181 8686 9010
ENV RMI_SERVER_HOSTNAME=localhost
ENV MAX_HEAP_SIZE=1g
ENV PAYARA_ARGS=""
ENV PAYARA_JVM_OPTIONS="-XX:+IgnoreUnrecognizedVMOptions -XX:+UseCompactObjectHeaders -XX:+UseStringDeduplication"

CMD ["sh", "-l", "-c", "/usr/share/payara/bin/run-payara.sh"]
