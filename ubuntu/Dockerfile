FROM i386/ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata

RUN apt-get update && apt-get install -y \
  tightvncserver xterm cabextract \
  wine

# mostly for dev 
RUN apt-get install -y \
  net-tools

RUN groupadd -g 1000 pcrfuel \
    && useradd -u 1000 -g pcrfuel -d /home/pcrfuel pcrfuel \
    && mkdir /home/pcrfuel \
    && chown -R pcrfuel:pcrfuel /home/pcrfuel

# run locale-gen en_us.utf-8
# env lang en_us.utf-8

run mkdir /opt && chown pcrfuel.pcrfuel /opt

user pcrfuel

WORKDIR /home/pcrfuel

# RUN dpkg --add-architecture i386 && apt-get update


ADD ../panther2-bundle-1.134.deb /opt
ADD ../EmeraldForecourtServices_2099.0.2.1362.cab /opt

# CMD ["/usr/bin/tightvncserver", ":0"]

ENTRYPOINT ["tail", "-f", "/dev/null"]

CMD ["/bin/bash", ":0"]

