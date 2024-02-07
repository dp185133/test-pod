#!/usr/bin/env bash
function publishports () {
    echo "-p 8182:8182 -p 3131:3131 -p 5006:5006/udp -p 1127:1127 -p 1128:1128/udp -p 5150:5150"
}
echo --% >/dev/null;: ' | out-null
<#'
JAGIP="192.168.6.2"

if [ "$1" == "" ]; then
    IMAGE="jacto:latest"
else
    IMAGE=$1
fi

########################################################################################
# https://stackoverflow.com/questions/39421131/is-it-possible-to-write-one-script-that-runs-in-bash-shell-and-powershell
########################################################################################

###################################################################################################
# NOTES:
#  --restart=unless-stopped will cause the container to always restart on exit, except with stop by docker
#        (this could be used to simulate re-boot, although we often reboot with the purpose of applying a persisted a change, so no bueno...
#         at least it could be used to perform a "refresh" system reboot )
#
# 
#

if false; then
    echo running with X sockets and host network
    docker run -h panther2 --name jag3 --net=host --env="DISPLAY" --volume="/tmp/.X11-unix:/tmp/.X11-unix" --volume="/home/matt/.Xauthority:/opt/.Xauthority" --volume="/home/matt/persist:/persist" -d -i -t $IMAGE  /bin/bash
else
    echo running no X no host network
# what was this "publishports"?
#    docker run -h panther2 --name jag3 --volume="/home/matt/persist:/persist" `publishports` -d -i -t $IMAGE  /bin/bash
    docker run -h panther2 --name jag3 --volume="/home/matt/persist:/persist" `publishports` -d -i -t $IMAGE  /bin/bash
fi

docker exec -it jag3 /opt/config/docker-configure-run.sh

exit 0
#>
$IMAGE="jacto:latest"

if ($false) {
    docker run -h panther2 --name jag3 --net=host --env="DISPLAY" --volume="/tmp/.X11-unix:/tmp/.X11-unix" --volume="/home/matt/.Xauthority:/opt/.Xauthority" --volume="/home/matt/persist:/persist" -d -i -t $IMAGE  /bin/bash
} else {
    docker run -h panther2 --name jag3 --volume="/persist:/persist" $(publishports) -d -i -t $IMAGE  /bin/bash
}

docker exec -it jag3 /opt/config/docker-configure-run.sh

# docker exec -it jag3 /bin/bash


