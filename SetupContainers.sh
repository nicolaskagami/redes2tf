#!/bin/bash
#1st ARG: ISOLATION TECHNOLOGY

ISOLATION=$1

case "$ISOLATION" in
    "0") #Nothing
        ISOLATION_PARAM=" \
            --cpu-quota=14000 \
            --cpu-period=10000 \
            --memory=1073741824 "
        ;;
    "1") #CGROUPS only
        ISOLATION_PARAM=" \
            --cpu-quota=14000 \
            --cpu-period=10000 \
            --memory=1073741824 "
        ;;
    "2") #AppArmor
        ISOLATION_PARAM="--security-opt apparmor=docker-default \
            --cpu-quota=14000 \
            --cpu-period=10000 \
            --memory=1073741824 "
        ;;
    "3") #CGROUPS and AppArmor
        ISOLATION_PARAM="--security-opt apparmor=docker-default \
            --cpu-quota=14000 \
            --cpu-period=10000 \
            --memory=1073741824 "
        ;;
esac
./clean.sh

docker run -it --cpuset-cpus="1" --privileged $ISOLATION_PARAM -d --network=none --name iperfServer iperf
docker run -it --cpuset-cpus="0" --privileged $ISOLATION_PARAM -d --network=none --name click click
docker run -it --cpuset-cpus="2" --privileged $ISOLATION_PARAM -d --network=none --name iperfClient iperf

VETH0_NAME="veth0"
VETH1_NAME="veth1"
VETH0_MAC="10:00:00:00:00:01"
VETH1_MAC="10:00:00:00:00:02"
ip link del $VETH0_NAME
ip link del $VETH1_NAME
ip link add $VETH0_NAME mtu 9000 type veth peer name $VETH1_NAME mtu 9000
pipework $VETH0_NAME -i eths click 172.16.0.2/24 $VETH1_MAC
pipework $VETH1_NAME -i eths iperfServer 172.16.0.1/24  $VETH0_MAC
ethtool -K $VETH0_NAME tso off
ethtool -K $VETH1_NAME tso off
docker exec -d iperfServer ip route add default via 172.16.0.2 dev eths
docker exec -d iperfServer arp -i eths -s 172.16.0.2 10:00:00:00:00:02
docker exec -d iperfServer arp -i eths -s 172.16.0.3 10:00:00:00:00:02
#docker exec -d click ip link set dev eth0 address $MAIN_MAC 

docker exec -d iperfServer iperf3 -s
