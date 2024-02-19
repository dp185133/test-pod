#!/usr/bin/env sh
echo --% >/dev/null;: ' | out-null
<#'


VXFUEL_BUNDLE=`ls -1 panther2-bundle*.deb`
VXFUEL_CAB=`ls -1 EmeraldForecourtServices_*.cab`

########################################################################################
# https://stackoverflow.com/questions/39421131/is-it-possible-to-write-one-script-that-runs-in-bash-shell-and-powershell
########################################################################################

rm config.tgz; tar -C ~/git/panther/panther-linux-install-bundler/build/panther2-bundle/opt/pcr/install -czf `pwd`/config.tgz panther2-jagless-linux-config

#>

echo docker build -t vxfuel --build-arg "VXFUEL_BUNDLE=$VXFUEL_BUNDLE" --build-arg "VXFUEL_CAB=$VXFUEL_CAB" .
docker build -t vxfuel --build-arg "VXFUEL_BUNDLE=$VXFUEL_BUNDLE" --build-arg "VXFUEL_CAB=$VXFUEL_CAB" .
