#!/bin/bash
#1st ARG: ANOMALY
ANOMALY=$1
case "$ANOMALY" in
    "0") 
        echo "No Anomaly"
        ;;
    "1") 
        echo "CPU Stress"
        ;;
    "2") 
        echo "Mem Stress"
        ;;
    "3") 
        echo "I/O Stress"
        ;;
    "4") 
        echo "Disk Stress"
        ;;
esac

