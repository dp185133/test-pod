#!/usr/bin/env sh
echo --% >/dev/null;: ' | out-null
<#'

VXFUEL_VER=$(ls -1rt EmeraldForecourtServices_*.cab | tail -n1 | awk 'match($0, /([0-9].*[0-9])/, ver) { print ver[1] }')
VXFUEL_CAB=EmeraldForecourtServices_${VXFUEL_VER}.cab
VXFUEL_MQTT=JAG_MQTT_Binaries_${VXFUEL_VER}.zip
VXFUEL_IMAGE_NAME=vxfuel

########################################################################################
# https://stackoverflow.com/questions/39421131/is-it-possible-to-write-one-script-that-runs-in-bash-shell-and-powershell
########################################################################################

rm config.tgz; tar -C ~/git/panther/panther-linux-install-bundler/build/panther2-bundle/opt/pcr/install -czf `pwd`/config.tgz panther2-jagless-linux-config

#>

echo docker build -t $VXFUEL_IMAGE_NAME --build-arg "VXFUEL_CAB=$VXFUEL_CAB" --build-arg "VXFUEL_MQTT=$VXFUEL_MQTT" -f Docker-yoctoplus .
docker build -t $VXFUEL_IMAGE_NAME --build-arg "VXFUEL_CAB=$VXFUEL_CAB" --build-arg "VXFUEL_MQTT=$VXFUEL_MQTT" -f Docker-yoctoplus .
