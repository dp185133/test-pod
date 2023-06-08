FROM scratch
ADD yocto-root.tgz /

run mkdir /opt && chown 701:701 /opt

COPY panther2-bundle-1.0.deb /opt/
RUN dpkg --install /opt/panther2-bundle-1.0.deb && rm -f /opt/panther2-bundle*.deb

###################################################################################################
# Temporary hack to copy in new config project changes; remove this for production which
# will get the 'latest' copy from the bundle
#######################################################
COPY config.tgz /opt/pcr/install
WORKDIR /opt/pcr/install
RUN tar -zxf config.tgz
###################################################################################################

WORKDIR /opt/pcr/install/panther2-jagless-linux-config
RUN /opt/pcr/install/panther2-jagless-linux-config/configure-linux.sh

COPY radstart /usr/bin
RUN chmod a+x /usr/bin/radstart

COPY bin/cabextract /usr/local/bin
COPY bin/libmspack.so.0 /usr/lib64



COPY EmeraldForecourtServices_2099.0.2.1362.cab /opt/
RUN mkdir /opt/efs-extract && (cd /opt/efs-extract; cabextract /opt/EmeraldForecourtServices_*.cab && rm -f /opt/EmeraldForecourtServices_*.cab)


user pcrfuel
WORKDIR /home/pcrfuel

RUN ln -s /opt/pcr/install/panther2-jagless-linux-config /opt/config

RUN ln -s /opt/.Xauthority /home/pcrfuel/.Xauthority

#WORKDIR /opt/pcr/install/panther2-jagless-linux-config
#RUN DISPLAY=:0 labushka all manifest=/opt/config/data/sdks.json


ENTRYPOINT ["/sbin/init"]
#ENTRYPOINT ["/usr/bin/tail", "-f", "/dev/null"]
# CMD ["/bin/bash", ":0"]
# CMD ["/usr/bin/tightvncserver", ":0"]

