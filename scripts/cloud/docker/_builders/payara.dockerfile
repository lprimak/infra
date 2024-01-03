FROM maven-builder
ARG PAYARA_6_VERSION=6.2023.12
ARG PAYARA_5_VERSION=5.2022.5

COPY download-payara.sh .
COPY pom.xml p-d-pom.xml
RUN apk --update --no-cache add zsh \
    && mkdir -p payara-download && mv p-d-pom.xml payara-download/pom.xml \
    && ./download-payara.sh $PAYARA_6_VERSION && mv payara-$PAYARA_6_VERSION /usr/share/payara \
    && ./download-payara.sh $PAYARA_5_VERSION && mv payara-$PAYARA_5_VERSION /usr/share/payara5 \
    && /usr/share/payara/bin/asadmin delete-domain --domaindir /usr/share/payara/glassfish/domains domain1 \
    && /usr/share/payara5/bin/asadmin delete-domain --domaindir /usr/share/payara5/glassfish/domains domain1 \
    && tar czf /var/build/payara-6.tar.gz -C /usr/share payara \
    && tar czf /var/build/payara-5.tar.gz -C /usr/share payara5

ENV HOME=/
ENV PATH="$PATH:/usr/share/payara/bin"
ENV AS_ADMIN_USER=admin
ENV AS_ADMIN_PASSWORDFILE=/var/build/payara-passwordfile

RUN echo "AS_ADMIN_PASSWORD=admin" > /var/build/payara-passwordfile \
    && asadmin create-domain default-domain \
    && asadmin start-domain \
    && asadmin enable-secure-admin \
    && asadmin set-log-attributes com.sun.enterprise.server.logging.GFFileHandler.logtoFile=false \
    && for MEMORY_JVM_OPTION in \
       $(asadmin list-jvm-options | grep "Xm[sx]\|Xss"); \
       do \
         asadmin delete-jvm-options $MEMORY_JVM_OPTION; \
       done \
    && asadmin create-jvm-options '-XX\:+UseContainerSupport:-XX\:MaxRAMPercentage=80' \
    && asadmin stop-domain \
    && rm -rf /var/payara-domains/default-domain/osgi-cache \
       /var/payara-domains/default-domain/logs && true \
    && tar czf /var/build/default-domain.tar.gz -C /var/payara-domains default-domain
