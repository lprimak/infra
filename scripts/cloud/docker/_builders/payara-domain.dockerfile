ARG PAYARA_VERSION
FROM payara-${PAYARA_VERSION}-builder

ENV HOME=/
ENV AS_ADMIN_USER=admin
ENV AS_ADMIN_PASSWORDFILE=/var/build/payara-passwordfile

RUN echo "AS_ADMIN_PASSWORD=admin" > /var/build/payara-passwordfile \
    && mkdir -p /var/payara-domains \
    && asadmin create-domain default-domain \
    && asadmin start-domain \
    && asadmin enable-secure-admin \
    && asadmin set-log-attributes com.sun.enterprise.server.logging.GFFileHandler.logtoFile=false \
    && for MEMORY_JVM_OPTION in \
       $(asadmin list-jvm-options | grep "Xm[sx]\|Xss"); \
       do \
         asadmin delete-jvm-options $MEMORY_JVM_OPTION; \
       done \
    && asadmin create-jvm-options '-XX\:+UseParallelGC:-XX\:MaxRAMPercentage=80' \
    && asadmin create-system-properties fish.payara.classloading.delegate=false \
    && asadmin stop-domain \
    && rm -rf /var/payara-domains/default-domain/osgi-cache \
       /var/payara-domains/default-domain/logs && true \
    && tar czf /var/build/default-domain.tar.gz -C /var/payara-domains default-domain
