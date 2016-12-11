#!/bin/bash
bash ./clean.sh
CAPABILITIES_OPTIONS="--privileged --cap-add NET_ADMIN"
CGROUP_OPTIONS="--cpu-quota=5000 --cpu-period=10000 --memory='1073741824' \
		--device-write-bps='/dev/sda:512mb' \
		--device-write-iops='/dev/sda:1000' \
		--device-read-bps='/dev/sda:512mb' \
		--device-read-iops='/dev/sda:1000' \
		--memory-swappiness='0' 
		--shm-size='0'"
docker run -it --privileged --cap-add NET_ADMIN -d --name click click
