# syntax = devthefuture/dockerfile-x
ARG USER=flowlogix
ARG HOME=/home/$USER
RUN addgroup -g 1000 $USER && addgroup -g 900 docker \
  && adduser -u 1000 -G $USER -D -g "" $USER \
  && addgroup $USER docker \
  && mkdir -p /etc/sudoers.d \
  && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
  && chmod 0440 /etc/sudoers.d/$USER \
  && chown -R $USER:$USER /home/$USER

USER $USER
INCLUDE java-options.dockerfile
WORKDIR $HOME
