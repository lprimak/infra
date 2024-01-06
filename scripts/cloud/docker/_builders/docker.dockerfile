FROM ubuntu

ENV FL_IS_BUILD_IMAGE=yes
COPY install-docker.sh /root
RUN ln -s /root/infra/scripts/cloud/docker /build \
    && /root/install-docker.sh \
    && mkdir -p /root/.ssh /root/.docker \
    && chmod 700 /root/.docker

CMD ["bash", "-l"]
