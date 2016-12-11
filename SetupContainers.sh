#!/bin/bash
#1st ARG: ISOLATION TECHNOLOGY
#2nd ARG: VIRTUALIZATION TECHNOLOGY
#3rd ARG: VNF

ISOLATION=$1
VIRTECH=$2
VNF=$3

if [ "$VIRTECH" -eq "0" ]
then
    echo "Docker"
else
    echo "LXD"
fi
if [ "$ISOLATION" -eq "0" ]
then
    echo "NO CGROUPS"
else
    echo "CGROUPS"
fi
if [ "$VNF" -eq "2" ]
then
    echo "Setting up NAT"
else
    echo "Setting up DPI/Firewall"
fi
docker kill click
docker kill iperfServer
docker kill iperfClient
./clean.sh
docker run -it --cpuset-cpus="4" --privileged -d --network=none --name iperfServer iperf
docker run -it --cpuset-cpus="1-3" --privileged  -d --network=none --name click click
docker run -it --cpuset-cpus="5" --privileged -d --network=none --name iperfClient iperf

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
#docker exec -d click ip link set dev eth0 address $MAIN_MAC 
