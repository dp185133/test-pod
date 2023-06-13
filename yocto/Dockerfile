FROM scratch
ADD yocto-root.tgz /


########################################################################################
# exposed ports
########################################################################################
# Not sure about the necessity of these; connections seem to work from our host without
# these even being present in expose statements, so... ??
EXPOSE 5901 # vncviewer
EXPOSE 3131 # radio commands
EXPOSE 5006/udp # radio heartbeats
EXPOSE 4237/udp # devman fault tolerance??
EXPOSE 1127 # teleq
expose 1128/udp # teleq heartbeats
expose 22 # ssh/dropbear
expose 452 # SiteTrust

expose 4780 # gilbarco
expose 4870 # gilbarco
expose 4871 # gilbarco
expose 5200/udp Gilbarco
expose 5150 # optic

expose 5160 # ICR connect
expose 5161 # ICR Connect

expose 5959 # IFSF FDC
expose 5960 # IFSF FDC

expose 8413 # Additech

expose 8181 # Icarus test interface
expose 8182 # BDD Services
expose 8183 # Devman test interface
expose 5200/udp # SMClient heartbeats

# SerialLink
expose 46886
expose 47142
expose 47654
expose 60120/udp

expose 1400 # Emerald / TcpCom?
expose 4004 # Kroger POS
expose 4006 # Shell Mobile
expose 5100 # Logger?
########################################################################################

COPY data/profile /etc/profile

# X11 necessities and tightvnc server
run mkdir -p /opt/pcr/data && chown -R 701:701 /opt
COPY data/vnc-passwd /opt/pcr/data
COPY bin/libjpeg.so.8 /usr/lib64/
ADD bin/x11.tgz /

COPY bin/tightvncserver_1.3.10-0ubuntu4_amd64.deb /opt/
RUN dpkg --ignore-depends=perl:any,libc6,libjpeg8,libx11-6,zlib1g,x11-common,xserver-common,x11-utils,xauth --install /opt/tightvncserver_1.3.10-0ubuntu4_amd64.deb 

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

RUN mkdir -p /opt/pcr/bin
COPY bin/BDDServices.exe /opt/pcr/bin


COPY EmeraldForecourtServices_2099.0.2.1362.cab /opt/
RUN mkdir /opt/efs-extract && (cd /opt/efs-extract; cabextract /opt/EmeraldForecourtServices_*.cab && rm -f /opt/EmeraldForecourtServices_*.cab)


# this is some ad-hoc crap here.  Somehow radstart expects these directories,
# maybe because we should have run Radio install before we run
# radstart?  I don't know.
RUN mkdir -p /home/pcrfuel/.wine/drive_c/Program\ Files/Radiant/FastPoint/Bin
RUN mkdir -p /home/pcrfuel/.wine/drive_c/Program\ Files/Radiant/FastPoint/Log
RUN mkdir -p /home/pcrfuel/.wine/drive_c/Program\ Files/Radiant/FastPoint/Data
RUN chown -R pcrfuel:pcrfuel /home/pcrfuel/.wine


user pcrfuel
WORKDIR /home/pcrfuel

RUN ln -s /opt/pcr/install/panther2-jagless-linux-config /opt/config

RUN ln -s /opt/.Xauthority /home/pcrfuel/.Xauthority




#ENTRYPOINT ["/sbin/init"]

# CMD ["/bin/bash", ":0"]
# CMD ["/usr/bin/tightvncserver", ":0"]

ENTRYPOINT ["/usr/bin/tail", "-f", "/dev/null"]
