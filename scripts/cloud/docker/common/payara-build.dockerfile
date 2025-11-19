ARG PAYARA_VERSION

ADD --unpack=true exports/payara-${PAYARA_VERSION}.tar.gz /usr/share
RUN echo "PATH=$PATH:/usr/share/payara/bin" >/etc/profile.d/payara-path.sh \
    && chmod a+x /etc/profile.d/payara-path.sh
