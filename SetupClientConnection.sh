#!/bin/bash
#1st ARG: VNF
#2nd ARG: INTERFACE
VNF=$1
INTERFACE=$2
if [ "$VNF" -eq "2" ]
then
    echo "Setting connection through NAT"
else
    echo "Setting normal connection"
fi
case "$INTERFACE" in
    "0") 
        echo "Setting Up Veth Double"
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
        pipework $VETH3_NAME -i ethc click 172.16.0.1/24 $VETH3_MAC
        pipework $VETH4_NAME -i ethc iperfClient 172.16.0.2/24 $VETH4_MAC
        docker exec -d iperfClient ip route add default via 172.16.0.1 dev ethc
        docker exec -d iperfClient arp -i ethc -s 172.16.0.1 10:00:00:00:00:01 
        ;;
    "2") 
        echo "Setting Up Macvlan Private"
        ;;
    "3") 
        echo "Setting Up Macvlan Bridge"
        ;;
esac
