ENV MAVEN_ARGS="-Dwebdriver.gecko.driver=/usr/bin/geckodriver"
ENV PAYARA_JACOCO_OPTIONS="-D_empty_jacoco=empty"
RUN /usr/share/payara/bin/asadmin create-domain --nopassword default-domain \
    && /usr/share/payara/bin/asadmin start-domain \
    && /usr/share/payara/bin/asadmin create-jvm-options '${ENV=PAYARA_JACOCO_OPTIONS}' \
    && rm -f $HOME/var/payara-domains/default-domain/logs/server.log
