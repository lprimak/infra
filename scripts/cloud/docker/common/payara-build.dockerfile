COPY exports/payara-6.tar.gz /tmp
COPY exports/payara-5.tar.gz /tmp
RUN tar zxf /tmp/payara-6.tar.gz -C /usr/share && rm -f /tmp/payara-6.tar.gz \
    && tar zxf /tmp/payara-5.tar.gz -C /usr/share && rm -f /tmp/payara-5.tar.gz \
    && echo "PATH=$PATH:/usr/share/payara/bin" >/etc/profile.d/payara-path.sh \
    && chmod a+x /etc/profile.d/payara-path.sh
