#!/bin/bash
VETH0_NAME="veth1"
VETH1_NAME="veth2"
VETH0_MAC="10:00:00:00:00:01"
VETH1_MAC="10:00:00:00:00:02"
MAIN_MAC="20:00:00:00:00:01"
ip link del $VETH0_NAME
ip link del $VETH1_NAME
ip link add $VETH0_NAME type veth peer name $VETH1_NAME
pipework $VETH0_NAME click 172.16.0.1/24 $VETH0_MAC
pipework $VETH1_NAME iperfServer 172.16.0.2/24 $VETH1_MAC
docker exec -d click ip link set dev eth0 address $MAIN_MAC 
ip route add 172.16.0.0/24 dev docker0
docker exec -d iperfServer ip route add default via 172.16.0.2 dev eth1
docker exec -d iperfServer arp -i eth1 -s 172.17.0.1 $VETH0_MAC 
arp -d 172.16.0.2
arp -s 172.16.0.2 $MAIN_MAC

#docker network create -d macvlan --subnet=172.1.0.2/24 --gateway=192.168.41.1 --ip-range=192.168.41.128/26 -o parent=eno1.1 macpri
