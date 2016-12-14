#!/bin/bash
#1st ARG: INTERFACE

INTERFACE=$1

function getIface()
{
   IFACE_PAIR=$(docker exec click ip a | grep eth0@ | cut -d 'f' -f2 | cut -d ':' -f1)
   IFACE=$(ip a | grep "^$IFACE_PAIR:" | cut -d ' ' -f2 | cut -d '@' -f1 | cut -d ':' -f1)
}

case "$INTERFACE" in
    "0") 
        echo "Setting Up Veth Double"
        VETH3_MAC="10:00:00:00:00:01"
        VETH5_MAC="10:00:00:00:00:02"

        docker network disconnect none click
        docker network disconnect none iperfClient
        docker network connect mybridge --ip 172.16.0.2 click
        docker network connect mybridge --ip 172.16.0.3 iperfClient

        getIface click
        echo $IFACE
        ethtool -K $IFACE tso off
        ip link set dev $IFACE mtu 9000
        getIface iperfClient
        ethtool -K $IFACE tso off
        ip link set dev $IFACE mtu 9000
        
        docker exec -d click ip link set dev eth0 address 10:00:00:00:00:01 mtu 9000
        docker exec -d iperfClient ip link set dev eth0 address 10:00:00:00:00:02 mtu 9000
        docker exec -d iperfClient arp -i eth0 -s 172.16.0.1 10:00:00:00:00:01 
        ;;
    "1") 
        echo "Setting Up Veth Direct"
        VETH3_NAME="veth3"
        VETH4_NAME="veth4"
        VETH3_MAC="10:00:00:00:00:01"
        VETH4_MAC="10:00:00:00:00:02"
        ip link del $VETH3_NAME
        ip link del $VETH4_NAME
        ip link add $VETH3_NAME mtu 9000 type veth peer name $VETH4_NAME mtu 9000
        ethtool -K $VETH3_NAME tso off
        ethtool -K $VETH4_NAME tso off
        pipework $VETH3_NAME -i eth0 click 172.16.0.1/24 $VETH3_MAC
        pipework $VETH4_NAME -i eth0 iperfClient 172.16.0.3/24 $VETH4_MAC
        docker exec -d iperfClient ip route add default via 172.16.0.1 dev eth0
        docker exec -d iperfClient arp -i eth0 -s 172.16.0.1 10:00:00:00:00:01 
        ;;
    "2") 
        echo "Setting Up Macvlan Bridge"
        docker network disconnect none click
        docker network disconnect none iperfClient
        docker network connect macvlanb --ip 172.16.0.2 click
        docker network connect macvlanb --ip 172.16.0.3 iperfClient

        getIface click
        echo $IFACE
        ethtool -K $IFACE tso off
        ip link set dev $IFACE mtu 9000
        getIface iperfClient
        ethtool -K $IFACE tso off
        ip link set dev $IFACE mtu 9000
        
        docker exec -d click ip link set dev eth0 address 10:00:00:00:00:01 mtu 9000
        docker exec -d iperfClient ip link set dev eth0 address 10:00:00:00:00:02 mtu 9000
        docker exec -d iperfClient arp -i eth0 -s 172.16.0.1 10:00:00:00:00:01 
        ;;
esac

