FROM i386/ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata

# mostly for dev 
RUN apt-get install -y \
  net-tools

RUN groupadd -g 1000 pcrfuel \
    && useradd -u 1000 -g pcrfuel -d /home/pcrfuel pcrfuel \
    && mkdir /home/pcrfuel \
    && chown -R pcrfuel:pcrfuel /home/pcrfuel

run mkdir -p /opt && chown pcrfuel.pcrfuel /opt

user pcrfuel

WORKDIR /home/pcrfuel

ENTRYPOINT ["tail", "-f", "/dev/null"]

CMD ["/bin/bash", ":0"]

