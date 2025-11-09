# syntax = devthefuture/dockerfile-x
ARG USER=flowlogix
ARG HOME=/home/$USER
RUN apt-get update && apt-get install -y sudo vim \
  && addgroup --gid 1000 $USER && addgroup --gid 900 docker \
  && adduser --uid 1000 --ingroup $USER --disabled-password $USER \
  && addgroup $USER docker && passwd -d $USER && usermod -aG sudo $USER \
  && chown -R $USER:$USER /home/$USER

USER $USER
INCLUDE java-options.dockerfile
WORKDIR $HOME
