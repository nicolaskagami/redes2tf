#!/bin/bash
#1st ARG: ANOMALY
ANOMALY=$1
ISOLATION=$2
DURATION=$3
case "$ISOLATION" in
    "0") #Nothing
        ISOLATION_PARAM=""
        ;;
    "1") #CGROUPS only
        ISOLATION_PARAM=" \
            --cpu-quota=1000 \
            --cpu-period=1000 \
            --kernel-memory=400M \
            --cpuset-cpus=4-5 \
            --memory=28073741824 \
            --memory-swappiness=0 \
            --device-write-bps=/dev/sda:512mb \
            --device-write-iops=/dev/sda:1000 \
            --device-read-bps=/dev/sda:512mb \
            --device-read-iops=/dev/sda:1000 \
            --shm-size=0"
        ;;
    "2") #AppArmor
        ISOLATION_PARAM="--security-opt apparmor=docker-default "
        ;;
    "3") #CGROUPS and AppArmor
        ISOLATION_PARAM="--security-opt apparmor=docker-default \
            --cpu-quota=1000 \
            --cpu-period=1000 \
            --kernel-memory=400M \
            --cpuset-cpus=4-5 \
            --memory=20073741824 \
            --memory-swappiness=0 \
            --device-write-bps=/dev/sda:512mb \
            --device-write-iops=/dev/sda:1000 \
            --device-read-bps=/dev/sda:512mb \
            --device-read-iops=/dev/sda:1000 \
            --shm-size=0"
        ;;
esac

case "$ANOMALY" in
    "0") 
        echo "No Anomaly"
        ;;
    "1") 
        echo "CPU Stress"
        docker run  -d $ISOLATION_PARAM -it progrium/stress --cpu 50 --timeout $DURATION >/dev/null 
        ;;
    "2") 
        echo "Mem Stress"
        docker run -d $ISOLATION_PARAM -it progrium/stress --vm 500 --vm-bytes 50485760 --vm-keep --timeout $DURATION >/dev/null 
        ;;
    "3") 
        echo "I/O Stress"
        docker run -d $ISOLATION_PARAM -it progrium/stress --io 50 --timeout $DURATION >/dev/null 
        ;;
    "4") 
        echo "Disk Stress"
        docker run -d $ISOLATION_PARAM -it progrium/stress --hdd 20 --hdd-bytes 203741824 --timeout $DURATION >/dev/null 
        ;;
esac

