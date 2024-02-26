FROM scratch

ARG VXFUEL_BUNDLE
ADD yocto-root.tgz /


# X11 necessities and tightvnc server
COPY bin/libjpeg.so.8 /usr/lib64/
ADD  bin/x11.tgz /

run mkdir -p /opt/pcr/container && chown -R 701:701 /opt
run mkdir -p /opt/log && chown 701:701 /opt/log



########################################################################################
# without a minimal 'init' process, the container accumulates zombie processes.
# So we steal a debian build of tini here to serve as our container init.
########################################################################################
run mkdir -p /opt/pkg

COPY bin/tini_0.19.0-1_amd64.deb /opt/pkg/
RUN dpkg --ignore-depends=libc6 --install /opt/pkg/tini_0.19.0-1_amd64.deb


########################################################################################
# PERL INSTALL FOR NEW ROOT
########################################################################################
COPY pkg/perl-base_5.28.1-6+deb10u1_amd64.deb /opt/pkg/
RUN dpkg --ignore-depends=dpkg,libc6,libcrypt1 --install /opt/pkg/perl-base_5.28.1-6+deb10u1_amd64.deb

COPY pkg/perl-modules-5.28_5.28.1-6+deb10u1_all.deb /opt/pkg/
RUN dpkg --ignore-depends=dpkg,libc6,libcrypt1 --install /opt/pkg/perl-modules-5.28_5.28.1-6+deb10u1_all.deb

COPY pkg/libperl5.28_5.28.1-6+deb10u1_amd64.deb /opt/pkg/
RUN dpkg --ignore-depends=dpkg,libc6,libcrypt1,libbz2-1.0,libdb5.3,libgdbm-compat4,libgdbm6,zlib1g --install /opt/pkg/libperl5.28_5.28.1-6+deb10u1_amd64.deb

COPY pkg/perl_5.28.1-6+deb10u1_amd64.deb /opt/pkg/



COPY bin/tightvncserver_1.3.10-0ubuntu4_amd64.deb /opt/
RUN dpkg --ignore-depends=perl:any,libc6,libjpeg8,libx11-6,zlib1g,x11-common,xserver-common,x11-utils,xauth --install /opt/tightvncserver_1.3.10-0ubuntu4_amd64.deb 

########################################################################################
# MOSQUITTO INSTALL FOR OLD ROOT
########################################################################################
# COPY bin/mosquitto_1.5.8-r0_amd64.deb /opt/
# RUN dpkg --force-all --ignore-depends=shadow,base-files,base-passwd,initd-functions,libc6,libcrypto1.1,libssl1.1,libsystemd0,libuuid1 --install /opt/mosquitto_1.5.8-r0_amd64.deb
# RUN dpkg --ignore-depends=shadow,base-files,base-passwd,initd-functions,libc6,libcrypto1.1,libssl1.1,libsystemd0,libuuid1 --unpack /opt/mosquitto_1.5.8-r0_amd64.deb
# RUN rm -f /var/lib/dpkg/info/mosquitto.postinst 
# RUN dpkg --ignore-depends=shadow,base-files,base-passwd,initd-functions,libc6,libcrypto1.1,libssl1.1,libsystemd0,libuuid1 --configure mosquitto
# COPY bin/libmosquitto1_1.5.8-r0_amd64.deb /opt/
# RUN dpkg --ignore-depends=libc6,libcrypto1.1,libssl1.1 --install /opt/libmosquitto1_1.5.8-r0_amd64.deb


COPY ${VXFUEL_BUNDLE} /opt/
RUN dpkg --install /opt/${VXFUEL_BUNDLE} && rm -f /opt/panther2-bundle*.deb
RUN rm -f /opt/pcr/pkg/crossover-panther1-*

