FROM maven-4-builder
ARG PAYARA_VERSION

COPY download-payara.sh .
COPY pom.xml p-d-pom.xml
ENV PATH="$PATH:/usr/share/payara/bin"
RUN apk --update --no-cache add zsh \
    && mkdir -p payara-download && mv p-d-pom.xml payara-download/pom.xml \
    && ./download-payara.sh $PAYARA_VERSION && mv payara-$PAYARA_VERSION /usr/share/payara \
    && asadmin delete-domain --domaindir /usr/share/payara/glassfish/domains domain1 \
    && tar czf /var/build/payara.tar.gz -C /usr/share payara
