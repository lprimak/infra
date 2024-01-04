ARG GECKODRIVER_VERSION

ARG TARGETOS
ARG TARGETARCH

ARG URL=https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-$TARGETOS

COPY geckodriver.sh .
RUN ./geckodriver.sh $URL $TARGETARCH \
 && tar -xzf /tmp/geckodriver.tar.gz -C /usr/bin/ geckodriver \
 && rm -f /tmp/geckodriver.tar.gz
