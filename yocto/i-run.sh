docker run -h panther2 --name jag3 --net=host --env="DISPLAY" --volume="/tmp/.X11-unix:/tmp/.X11-unix" --volume="/home/matt/.Xauthority:/root/.Xauthority" --volume="/home/matt/contained:/opt/contained" -d -i -t $1  /bin/bash

