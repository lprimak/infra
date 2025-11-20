ENV MAVEN_ARGS="-Dwebdriver.gecko.driver=/usr/bin/geckodriver"
RUN /usr/share/payara/bin/asadmin create-domain --nopassword default-domain \
    && /usr/share/payara/bin/asadmin start-domain
