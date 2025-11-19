FROM maven-4-builder
ARG PAYARA_VERSION
ARG DISTRIBUTION_PACKAGE
ARG PAYARA_DEST=/usr/share/payara

COPY download-payara.sh .
COPY pom.xml p-d-pom.xml
ENV PATH="$PATH:/usr/share/payara/bin"
RUN mkdir -p /root/.m2/
COPY agent-maven-settings.xml /root/.m2/settings.xml
RUN apk --update --no-cache add zsh \
    && mkdir -p payara-download && mv p-d-pom.xml payara-download/pom.xml \
    && ./download-payara.sh $PAYARA_VERSION $DISTRIBUTION_PACKAGE \
    && mv payara-$PAYARA_VERSION $PAYARA_DEST \
    && asadmin delete-domain --domaindir $PAYARA_DEST/glassfish/domains domain1 \
    && rm -rf $PAYARA_DEST/h2db/src $PAYARA_DEST/h2db/service $PAYARA_DEST/h2db/docs \
       $PAYARA_DEST/glassfish/h2db/src $PAYARA_DEST/mq/javadoc $PAYARA_DEST/mq/examples \
    && tar czf /var/build/payara.tar.gz -C /usr/share payara
