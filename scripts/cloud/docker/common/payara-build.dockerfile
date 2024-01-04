ARG PAYARA_VERSION

COPY exports/payara-${PAYARA_VERSION}.tar.gz /tmp/payara.tar.gz
RUN tar zxf /tmp/payara.tar.gz -C /usr/share && rm -f /tmp/payara.tar.gz \
    && echo "PATH=$PATH:/usr/share/payara/bin" >/etc/profile.d/payara-path.sh \
    && chmod a+x /etc/profile.d/payara-path.sh
