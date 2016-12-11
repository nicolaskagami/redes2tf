#!/bin/bash
#1st ARG: ISOLATION TECHNOLOGY

ISOLATION=$1
case "$ISOLATION" in
    "0") 
        echo "Setting Up No Isolation"
        ;;
    "1") 
        echo "Setting Up CGROUPS Only"
        ;;
    "2") 
        echo "Setting Up CGROUPS and APParmor"
        ;;
    "3") 
        echo "Setting Up CGROUPS and SELinux"
        ;;
esac
