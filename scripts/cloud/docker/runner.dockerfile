# syntax = devthefuture/dockerfile-x
FROM ubuntu:latest

ENV USER=flowlogix
RUN apt update && apt install -y sudo vim \
  && addgroup --gid 1000 $USER && addgroup --gid 900 docker \
  && adduser --uid 1000 --ingroup $USER --disabled-password $USER \
  && addgroup $USER docker && passwd -d $USER && usermod -aG sudo $USER
ENV HOME=/home/$USER
WORKDIR $HOME
USER $USER

CMD ["bash", "-l"]
