FROM scratch
ADD yocto-root.tgz /

#RUN groupadd -g 1001 pcrfuel
#
#RUN useradd -u 1001 -g pcrfuel -d /home/pcrfuel pcrfuel \
#    && chown -R pcrfuel:pcrfuel /home/pcrfuel

#    && mkdir /home/pcrfuel \

# run locale-gen en_us.utf-8
# env lang en_us.utf-8

run mkdir /opt && chown 701:701 /opt

# user pcrfuel

# WORKDIR /home/pcrfuel

COPY panther2-bundle-1.134.deb /opt/
# COPY EmeraldForecourtServices_2099.0.2.1362.cab /opt/

ENTRYPOINT ["/usr/bin/tail", "-f", "/dev/null"]

CMD ["/bin/bash", ":0"]
# CMD ["/usr/bin/tightvncserver", ":0"]

