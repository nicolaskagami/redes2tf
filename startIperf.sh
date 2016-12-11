#!/bin/bash
bash ./clean.sh
CAPABILITIES_OPTIONS="--privileged --cap-add NET_ADMIN"
docker run --network=none -it --privileged --cap-add NET_ADMIN -d --name iperf iperf 
